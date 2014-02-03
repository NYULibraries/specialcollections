# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Findingaids::Catman

  SolrDocument.use_extension ::Findingaids::Exports

  before_filter :get_component, :get_component_children, :show_item_within_collection, :only => :show

  configure_blacklight do |config|
    #config.default_solr_params = {
    #  :qt => "",
    #  :rows => 10,
    #  ("hl.fl").to_sym => "title_ssm, author_ssm, publisher_ssm, collection_ssm,parent_unittitles_ssm,location_ssm",
    #  ("hl.simple.pre").to_sym => '<span class="label label-info">',
    #  ("hl.simple.post").to_sym => "</span>",
    #  :hl => true
    #}
    
    config.default_solr_params = {
      :qt => '',
      :rows => 10,
      :fl => "*",
      #:qf => "publisher_display^10.0 title_unstem_search^10.0 title_t^10.0 title_num_t^10.0 abstract_t^9.0 controlaccess_t^9.0 scopecontent_t^7.0 bioghist_t^7.0 unittitle_t^5.0 odd_t^5.0 index_t^3.0 phystech_t^2.0 acqinfo_t^2.0 sponsor_t^1.0 custodhist_t^1.0",
      #:pf => "publisher_display^10.0 title_unstem_search^11.0 title_t^10.0 title_num_t^11.0 abstract_t^10.0 controlaccess_t^10.0 scopecontent_t^8.0 bioghist_t^8.0 unittitle_t^6.0 odd_t^6.0 index_t^4.0 phystech_t^3.0 acqinfo_t^3.0 sponsor_t^2.0 custodhist_t^2.0",
      #("hl.fl").to_sym => "publisher_display title_unstem_search title_t  title_num_t abstract_t controlaccess_t scopecontent_t bioghist_t unittitle_t odd_t index_t phystech_t acqinfo_t sponsor_t custodhist_t",
      "hl.simple.pre" => "<span class=\"highlight\">",
      "hl.simple.post" => "</span>",
      "hl.mergeContiguous" => true,
      "hl.fragsize" => 50,
      "hl.snippets" => 10,
      :hl => true,
      :facet => true,
      "facet.mincount" => 1,
      :echoParams => "explicit",
      :ps => 50,
      :defType => "edismax"
    }

    config.default_document_solr_params = {
      :qt => "",
      ("hl.fl").to_sym => "title_ssm, author_ssm, publisher_ssm, collection_ssm,parent_unittitles_ssm,location_ssm",
      ("hl.simple.pre").to_sym => '<span class="label label-info">',
      ("hl.simple.post").to_sym => "</span>",
      :hl => true
    }

    # solr field configuration for search results/index views
    config.index.show_link = solr_name("heading", :displayable)
    config.index.record_display_type = solr_name("format", :displayable)

    # solr field configuration for document/show views
    config.show.html_title = solr_name("heading", :displayable)
    config.show.heading = solr_name("heading", :displayable)
    config.show.display_type = solr_name("format", :displayable)

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    config.add_facet_field solr_name("format",     :facetable), :label => "Format",             :limit => 20
    config.add_facet_field solr_name("collection", :facetable), :label => "Collection Name",    :limit => 20
    config.add_facet_field solr_name("material",   :facetable), :label => "Archival Material",  :limit => 20
    config.add_facet_field solr_name("name",       :facetable), :label => "Name",               :limit => 20
    config.add_facet_field solr_name("subject",    :facetable), :label => "Subject",            :limit => 20
    config.add_facet_field solr_name("genre",      :facetable), :label => "Genre",              :limit => 20    
    config.add_facet_field solr_name("series",     :facetable), :label => "Event/Series",       :limit => 20
    config.add_facet_field solr_name("pub_date",   :facetable), :label => "Publication Date",   :limit => 20
    config.add_facet_field solr_name("language",   :facetable), :label => "Language",           :limit => true
    
    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!
    
    
    # ------------------------------------------------------------------------------------------
    #
    # Index view fields
    #
    # ------------------------------------------------------------------------------------------
    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name("title",             :displayable),  :label => "Title:", 
                                                                          :highlight => true

    config.add_index_field solr_name("author",            :displayable),  :label => "Author:", 
                                                                          :helper_method => :render_facet_link,
                                                                          :highlight => true
    
    config.add_index_field solr_name("format",            :displayable),  :label => "Format:"
    config.add_index_field solr_name("ohlink_url",        :displayable),  :label => "OhioLink Resource:", 
                                                                          :helper_method => :render_external_link

    config.add_index_field solr_name("resource_url",      :displayable),  :label => "Online Resource:",
                                                                          :helper_method => :render_external_link

    config.add_index_field solr_name("language",          :displayable),  :label => "Language:"
    config.add_index_field solr_name("publisher",         :displayable),  :label => "Publisher:"
    config.add_index_field solr_name("lc_callnum",        :displayable),  :label => "Call Number:"
    config.add_index_field solr_name("unitdate",          :displayable),  :label => "Dates:"

    config.add_index_field solr_name("collection",        :displayable),  :label => "Archival Collection:", 
                                                                          :helper_method => :render_facet_link,
                                                                          :highlight => true
                                                                         
    config.add_index_field solr_name("parent_unittitles", :displayable),  :label => "Series:",
                                                                          :highlight => true

    config.add_index_field solr_name("location",          :displayable),  :label => "Location:",
                                                                          :highlight => true

    config.add_index_field solr_name("material",          :displayable),  :label => "Archival Material:",
                                                                          :helper_method => :render_facet_link,
                                                                          :highlight => true                                                                      

    # ------------------------------------------------------------------------------------------
    #
    # Show view fields (individual record)
    #
    # ------------------------------------------------------------------------------------------
    # solr fields to be displayed in the show (single result) view
    # The ordering of the field names is the order of the display
    # None of these fields apply to ead documents or components
    config.add_show_field solr_name("title",        :displayable),  :label => "Title:", 
                                                                    :highlight => true,
                                                                    :itemprop => "name"

    config.add_show_field solr_name("unititle",     :displayable),  :label => "Uniform Title:",
                                                                    :itemprop => "alternateName"
                                                                    
    config.add_show_field solr_name("title_addl",   :displayable),  :label => "Additional Titles:",
                                                                    :itemprop => "alternativeHeadline"

    config.add_show_field solr_name("author",       :displayable),  :label          => "Author:",
                                                                    :helper_method  => :render_facet_link,
                                                                    :facet          => solr_name("name", :facetable),
                                                                    :highlight      => true,
                                                                    :itemprop       => "author"

    config.add_show_field solr_name("edition",      :displayable),  :label => "Edition:", :itemprop => "bookEdition"

    config.add_show_field solr_name("series",       :displayable),  :label          => "Series:",
                                                                    :helper_method  => :render_facet_link,
                                                                    :facet          => solr_name("series", :facetable)

    config.add_show_field solr_name("format",       :displayable),  :label => "Format:"
    config.add_show_field solr_name("format_dtl",   :displayable),  :label => "Format Details:"
    config.add_show_field solr_name("unitdate",     :displayable),  :label => "Dates:"

    config.add_show_field solr_name("ohlink_url",   :displayable), :label           => "OhioLink Resource:",
                                                                   :helper_method   => :render_external_link, 
                                                                   :text            => solr_name("ohlink_text", :displayable)
    
    config.add_show_field solr_name("resource_url", :displayable), :label           => "Online Resource:",     
                                                                   :helper_method   => :render_external_link, 
                                                                   :text            => solr_name("resource_text", :displayable)
    
    config.add_show_field solr_name("physical_dtl", :displayable),  :label => "Physical Details:"
    config.add_show_field solr_name("summary",      :displayable),  :label => "Summary:",
                                                                    :itemprop => "description"

    config.add_show_field solr_name("participants", :displayable),  :label => "Participants:"
    config.add_show_field solr_name("recinfo",      :displayable),  :label => "Recording Info:"
    config.add_show_field solr_name("contents",     :displayable),  :label => "Contents:"
    config.add_show_field solr_name("donor",        :displayable),  :label => "Donor:"

    config.add_show_field solr_name("collection",   :displayable),  :label         => "Archival Collection:", 
                                                                    :helper_method => :render_facet_link,
                                                                    :facet         => solr_name("collection", :facetable),
                                                                    :highlight     => true
    
    config.add_show_field solr_name("access",       :displayable),  :label => "Access:"

    config.add_show_field solr_name("subject",      :displayable),  :label         => "Subjects:",
                                                                    :helper_method => :render_subjects

    config.add_show_field solr_name("genre",        :displayable),  :label         => "Genre/Form:",
                                                                    :helper_method => :render_facet_link,
                                                                    :facet         => solr_name("genre", :facetable),
                                                                    :itemprop      => "genre"

    config.add_show_field solr_name("contributors", :displayable),  :label         => "Contributors:",
                                                                    :helper_method => :render_facet_link,
                                                                    :facet         => solr_name("name", :facetable),
                                                                    :itemprop      => "contributor"

    config.add_show_field solr_name("relworks",     :displayable),  :label         => "Related Works:",
                                                                    :helper_method => :render_search_link

    config.add_show_field solr_name("relitems",     :displayable),  :label => "Related Items:"
    config.add_show_field solr_name("item_link",    :displayable),  :label => "Item Links:"
    config.add_show_field solr_name("pub_date",     :displayable),  :label => "Dates of Publication:"
    config.add_show_field solr_name("freq",         :displayable),  :label => "Current Frequency:"
    config.add_show_field solr_name("freq_former",  :displayable),  :label => "Former Frequency:"
    config.add_show_field solr_name("language",     :displayable),  :label => "Language:"

    config.add_show_field solr_name("publisher",    :displayable),  :label      => "Publisher:",
                                                                    :highlight  => true

    config.add_show_field solr_name("lc_callnum",   :displayable),  :label => "Call Number:"
    config.add_show_field solr_name("isbn",         :displayable),  :label => "ISBN:", :itemprop => "isbn"
    config.add_show_field solr_name("issn",         :displayable),  :label => "ISSN:"
    config.add_show_field solr_name("upc",          :displayable),  :label => "UPC:"
    config.add_show_field solr_name("pubnum",       :displayable),  :label => "Publisher Number:"
    config.add_show_field solr_name("oclc",         :displayable),  :label => "OCLC No:"
 
    # Fields specific to ead components
    config.add_show_field solr_name("scopecontent",      :displayable), :label => "Scope and Content:", :itemprop => "description"
    config.add_show_field solr_name("separatedmaterial", :displayable), :label => "Separated Material:"
    config.add_show_field solr_name("accessrestrict",    :displayable), :label => "Access Restrictions:"
    config.add_show_field solr_name("accruals",          :displayable), :label => "Accruals:"
    config.add_show_field solr_name("acqinfo",           :displayable), :label => "Acquistions:"
    config.add_show_field solr_name("altformavail",      :displayable), :label => "Alt. Form:"
    config.add_show_field solr_name("appraisal",         :displayable), :label => "Appraisal:"
    config.add_show_field solr_name("arrangement",       :displayable), :label => "Arrangement:"
    config.add_show_field solr_name("custodhist",        :displayable), :label => "Custodial History:"
    config.add_show_field solr_name("fileplan",          :displayable), :label => "File Plan:"
    config.add_show_field solr_name("originalsloc",      :displayable), :label => "Originals:"
    config.add_show_field solr_name("phystech",          :displayable), :label => "Physical Tech:"
    config.add_show_field solr_name("processinfo",       :displayable), :label => "Processing:"
    config.add_show_field solr_name("relatedmaterial",   :displayable), :label => "Related Material:"
    config.add_show_field solr_name("userestrict",       :displayable), :label => "Usage Restrictions:"
    config.add_show_field solr_name("physdesc",          :displayable), :label => "Physical Description:"
    config.add_show_field solr_name("langmaterial",      :displayable), :label => "Language:"
    config.add_show_field solr_name("note",              :displayable), :label => "Notes:"
    config.add_show_field solr_name("accession",         :displayable), :label => "Accession Numbers:"
    config.add_show_field solr_name("print_run",         :displayable), :label => "Limited Print Run:"
    config.add_show_field solr_name("dimensions",        :displayable), :label => "Dimensions:"

    config.add_show_field solr_name("location",          :displayable), :label     => "Location:",
                                                                        :highlight => true

    config.add_show_field solr_name("material",          :displayable), :label          => "Archival Material:",
                                                                        :helper_method  => :render_facet_link,
                                                                        :facet          => solr_name("material", :facetable),
                                                                        :highlight      => true

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field "score desc, title_si asc, pub_date_si desc", :label => "relevance"
    config.add_sort_field "pub_date_si desc, title_si asc",             :label => "year"
    config.add_sort_field "author_si asc, title_si asc",                :label => "author"
    config.add_sort_field "title_si asc",                               :label => "title"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
    
    YAML.load_file( File.join(Rails.root, "config", "repositories.yml") )["Catalog"]["repositories"].each do |coll|
      config.add_search_field(coll.last["display"]) do |field|
       field.solr_parameters = { :fq => "repository_s:#{(coll.last["admin_code"].present?) ? coll.last["admin_code"] : '*'}" }
      end
    end
  end

end
