# frozen_string_literal: true
class CatalogController < ApplicationController
  include Blacklight::Catalog
  include BlacklightAdvancedSearch::Controller
  include Findingaids::Solr::CatalogHelpers
  delegate :is_collection?, to: :view_context

  configure_blacklight do |config|

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send on single-document requests to Solr. These settings are the Blacklight defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    config.default_solr_params = {
      :fl => display_fields,
      :qf => qf_fields,
      :pf => pf_fields,
      :bq => bq_fields,
      :facet => true,
      "facet.mincount" => 1,
      :ps => 50,
      :defType => "edismax",
      :timeAllowed => -1
    }

    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_solr_parameters] = {
        "facet" => true,
        "facet.field" => advanced_facet_fields.map {|facet| solr_name(facet[:field], :facetable)},
        "facet.limit" => -1, # return all facet values
        "facet.sort" => "count" # sort by byte order of values
      }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    # solr field configuration for search results/index views
    config.index.title_field = solr_name("heading", :displayable)
    config.index.display_type_field = solr_name("format", :displayable)

    config.add_field_configuration_to_solr_request!

    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

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
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)
    #
    # config.add_facet_field 'example_pivot_field', label: 'Pivot Field', :pivot => ['format', 'language_facet']
    #
    # config.add_facet_field 'example_query_facet_field', label: 'Publish Date', :query => {
    #    :years_5 => { label: 'within 5 Years', fq: "pub_date:[#{Time.zone.now.year - 5 } TO *]" },
    #    :years_10 => { label: 'within 10 Years', fq: "pub_date:[#{Time.zone.now.year - 10 } TO *]" },
    #    :years_25 => { label: 'within 25 Years', fq: "pub_date:[#{Time.zone.now.year - 25 } TO *]" }
    # }

    facet_fields.each do |facet|
      config.add_facet_field solr_name(facet[:field], :facetable), label: facet[:label], helper_method: facet[:helper_method], limit: (facet[:limit] || 20)
    end


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name("format",            :displayable),  :label => "Format", :helper_method => :render_field_item
    config.add_index_field solr_name("heading",           :displayable),  :label => "Contained in", :helper_method => :render_contained_in_links, unless: :is_collection?
    config.add_index_field solr_name("unitdate",          :displayable),  :label => "Date range", :helper_method => :render_field_item
    config.add_index_field solr_name("abstract",          :displayable),  :label => "Abstract", :helper_method => :render_field_item
    config.add_index_field solr_name("collection",        :displayable),  :label => "Archival Collection", :helper_method => :render_parent_facet_link
    config.add_index_field solr_name("repository",        :stored_sortable), label: "Library", helper_method: :render_repository_link
    config.add_index_field solr_name("unitid",            :displayable),  :label => "Call no", :helper_method => :render_field_item, if: :is_collection?
    config.add_index_field solr_name("collection_unitid", :displayable),  :label => "Collection call no", :helper_method => :render_field_item, unless: :is_collection?
    config.add_index_field solr_name("location",          :displayable),  :label => "Location", :helper_method => :render_field_item

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    #
    # config.add_search_field 'all_fields', label: 'All Fields'
    #
    #
    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    #
    # config.add_search_field('title') do |field|
    #   # solr_parameters hash are sent to Solr as ordinary url query params.
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'title' }
    #
    #   # :solr_local_parameters will be sent using Solr LocalParams
    #   # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    #   # Solr parameter de-referencing like $title_qf.
    #   # See: http://wiki.apache.org/solr/LocalParams
    #   field.solr_local_parameters = {
    #     qf: '$title_qf',
    #     pf: '$title_pf'
    #   }
    # end
    #
    # config.add_search_field('author') do |field|
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
    #   field.solr_local_parameters = {
    #     qf: '$author_qf',
    #     pf: '$author_pf'
    #   }
    # end
    #

    config.add_search_field("all_fields",
      :label => "All Fields",
      :advanced_parse => false,
      :include_in_advanced_search => true
    )

    ##
    # Add repository field query from config file
    Findingaids::Repositories.repositories.each do |coll|
      config.add_search_field(coll.last["url_safe_display"],
        :label => coll.last["display"],
        :solr_parameters => { :fq => "#{solr_name("repository", :stored_sortable)}:#{(coll.last["admin_code"].present?) ? coll.last["admin_code"].to_s : '*'}" },
        :advanced_parse => false,
        :include_in_advanced_search => false
        )
    end

    ##
    # Add advanced search fields
    advanced_search_fields.each do |field|
      config.add_search_field(solr_name(field[:field],:searchable),
        :label => field[:label],
        :include_in_advanced_search => true,
        :include_in_simple_select => false,
        :solr_parameters => { :qf => (field[:qf] || solr_name(field[:field], :searchable)) }
      )
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', label: 'relevance'
    # config.add_sort_field 'pub_date_sort desc, title_sort asc', label: 'year'
    # config.add_sort_field 'author_sort asc, title_sort asc', label: 'author'
    # config.add_sort_field 'title_sort asc, pub_date_sort desc', label: 'title'
    config.add_sort_field "score desc",                   :label => "relevance"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
  end

  # We need to override Blacklight's `index` in order to remediate the Solr response.
  def index
    (@response, @document_list) = search_results(params)

    remediate_solr_response

    respond_to do |format|
      format.html { store_preferred_view }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
      format.json do
        @presenter = Blacklight::JsonPresenter.new(@response,
                                                   @document_list,
                                                   facets_from_request,
                                                   blacklight_config)
      end
      additional_response_formats(format)
      document_export_formats(format)
    end
  end

  def remediate_solr_response()
    # There should only ever be one facet value in the Digital Content facet:
    # "Online Access":
    #     - https://github.com/NYULibraries/ead_indexer/blob/a367ab8cc791376f0d8a287cbcd5b6ee43d5c04f/lib/ead_indexer/behaviors.rb#L117
    #     - https://github.com/NYULibraries/ead_indexer/blob/a367ab8cc791376f0d8a287cbcd5b6ee43d5c04f/config/locales/en.yml#L5
    #
    # Due to a misconfiguration in this project's config/locales/en.yml file:
    #     https://github.com/NYULibraries/specialcollections/blob/2d89e389c8eb97413e8758ac1f0b2d53621b79e7/config/locales/en.yml#L65
    # ...the indexing jobs incorrectly set the `dao_sim` field to "translation missing: en.ead_indexer.fields.dao"
    # for a great many Solr documents.
    #
    # To fix this, we assume that any Digital Content facet value other than
    # "Online Access" is a mistake, and that "Online Access" should be the only
    # facet value, with all counts included under it.
    digital_content_facet_array = @response.facet_counts['facet_fields']['dao_sim']

    if ! digital_content_facet_array.empty?
      online_access_total = 0

      (1...digital_content_facet_array.length).step(2).each do |index|
        online_access_total += digital_content_facet_array[index]
      end

      @response.facet_counts['facet_fields']['dao_sim'] = ['Online Access', online_access_total]
    end
  end
end


