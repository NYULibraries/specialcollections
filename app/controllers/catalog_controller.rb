# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  
  include Blacklight::Catalog
  
  # Set a session variable on index action stating what the user's current collection is
  # so this will persist through their searching until they go to a new collection
  before_filter :set_session_collection, :only => :index
  # Before each search add the collection parameter to the list of parameters so it persists after the initial search
  before_filter :add_collection_param_to_search
  
  configure_blacklight do |config|
      ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
      
      config.default_solr_params = { 
        :qt => '',
        :rows => 10,
        :fl => "*",
        :facet => true,
        "facet.mincount" => 1,
        :echoParams => "explicit",
        :fq => "",
        #:qf => "title_texts^5.0 description_texts",
        #:pf => "title_texts^5.0 description_texts",
        :defType => "edismax"
      }

      ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or 
      ## parameters included in the Blacklight-jetty document requestHandler.
      #
      config.default_document_solr_params = {
        :qt => '',
        ## These are hard-coded in the blacklight 'document' requestHandler
        :fl => '*',
        :fq => "",
        :rows => 1,
        :q => "{!raw f=#{SolrDocument.unique_key} v=$id}"
      }

      # solr field configuration for search results/index views
      config.index.show_link = 'title_display'
      config.index.record_display_type = 'format'

      # solr field configuration for document/show views
      config.show.html_title = 'title_display'
      config.show.heading = 'title_display'
      config.show.display_type = 'format'

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
      config.add_facet_field 'format', :label => 'Format'
      config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
      config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 20 
      config.add_facet_field 'language_facet', :label => 'Language', :limit => true 
      config.add_facet_field 'lc_1letter_facet', :label => 'Call Number' 
      config.add_facet_field 'subject_geo_facet', :label => 'Region' 
      config.add_facet_field 'subject_era_facet', :label => 'Era'  

      config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

      config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
         :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
         :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
         :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
      }


      # Have BL send all facet field names to Solr, which has been the default
      # previously. Simply remove these lines if you'd rather use Solr request
      # handler defaults, or have no facets.
      config.add_facet_fields_to_solr_request!

      # solr fields to be displayed in the index (search results) view
      #   The ordering of the field names is the order of the display 
      config.add_index_field 'title_display', :label => 'Title:' 
      config.add_index_field 'title_vern_display', :label => 'Title:' 
      config.add_index_field 'author_display', :label => 'Author:' 
      config.add_index_field 'author_vern_display', :label => 'Author:' 
      config.add_index_field 'format', :label => 'Format:' 
      config.add_index_field 'language_facet', :label => 'Language:'
      config.add_index_field 'published_display', :label => 'Published:'
      config.add_index_field 'published_vern_display', :label => 'Published:'
      config.add_index_field 'lc_callnum_display', :label => 'Call number:'

      # solr fields to be displayed in the show (single result) view
      #   The ordering of the field names is the order of the display 
      config.add_show_field 'title_display', :label => 'Title:' 
      config.add_show_field 'title_vern_display', :label => 'Title:' 
      config.add_show_field 'subtitle_display', :label => 'Subtitle:' 
      config.add_show_field 'subtitle_vern_display', :label => 'Subtitle:' 
      config.add_show_field 'author_display', :label => 'Author:' 
      config.add_show_field 'author_vern_display', :label => 'Author:' 
      config.add_show_field 'format', :label => 'Format:' 
      config.add_show_field 'url_fulltext_display', :label => 'URL:'
      config.add_show_field 'url_suppl_display', :label => 'More Information:'
      config.add_show_field 'language_facet', :label => 'Language:'
      config.add_show_field 'published_display', :label => 'Published:'
      config.add_show_field 'published_vern_display', :label => 'Published:'
      config.add_show_field 'lc_callnum_display', :label => 'Call number:'
      config.add_show_field 'isbn_t', :label => 'ISBN:'

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

      config.add_search_field 'all_fields', :label => 'All Fields'


      # Now we see how to over-ride Solr request handler defaults, in this
      # case for a BL "search field", which is really a dismax aggregate
      # of Solr search fields. 

      config.add_search_field('title') do |field|
        # solr_parameters hash are sent to Solr as ordinary url query params. 
        field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

        # :solr_local_parameters will be sent using Solr LocalParams
        # syntax, as eg {! qf=$title_qf }. This is neccesary to use
        # Solr parameter de-referencing like $title_qf.
        # See: http://wiki.apache.org/solr/LocalParams
        field.solr_local_parameters = { 
          :qf => '$title_qf',
          :pf => '$title_pf'
        }
      end

      config.add_search_field('author') do |field|
        field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
        field.solr_local_parameters = { 
          :qf => '$author_qf',
          :pf => '$author_pf'
        }
      end

      # Specifying a :qt only to show it's possible, and so our internal automated
      # tests can test it. In this case it's the same as 
      # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
      config.add_search_field('subject') do |field|
        field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
        field.qt = 'search'
        field.solr_local_parameters = { 
          :qf => '$subject_qf',
          :pf => '$subject_pf'
        }
      end

      # "sort results by" select (pulldown)
      # label in pulldown is followed by the name of the SOLR field to sort by and
      # whether the sort is ascending or descending (it must be asc or desc
      # except in the relevancy case).
      config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
      config.add_sort_field 'pub_date_sort desc, title_sort asc', :label => 'year'
      config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
      config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

      # If there are more than this many search results, no spelling ("did you 
      # mean") suggestion is offered.
      config.spell_max = 5
  end
  
  # Initially defined in lib/blacklight/solr_helper.rb, this array is looped through to form search parameters
  # This is the standard way of adding search params to a solr search
  self.solr_search_params_logic << :add_collection_to_solr
  
  # Adding a collection to solr params
  def add_collection_to_solr(solr_parameters, user_parameters)
    #solr_parameters[:fq] << "collection_ss:#{current_collection(user_parameters[:collection])}" unless current_collection(user_parameters[:collection]).nil?
  end
  
  # This is an override of lib/blacklight/catalog.rb#save_current_search_params
  #
  # The original function creates a Search instance after each search to track search history
  # Our implementation of Blacklight will not serialize the query_params for some reason if the utf8 param is present
  #
  # TODO: Write a test to show how this fails in Blacklight and add back to core code 
  def save_current_search_params    
    # If it's got anything other than controller, action, total, we
    # consider it an actual search to be saved. Can't predict exactly
    # what the keys for a search will be, due to possible extra plugins.
    return if (search_session.keys - [:controller, :action, :total, :counter, :commit ]) == [] 
    params_copy = search_session.clone # don't think we need a deep copy for this
    params_copy.delete(:page)
    params_copy.delete(:utf8) # Added this line
    
    unless @searches.collect { |search| search.query_params }.include?(params_copy)
      new_search = Search.create(:query_params => params_copy)
      session[:history].unshift(new_search.id)
      # Only keep most recent X searches in history, for performance. 
      # both database (fetching em all), and cookies (session is in cookie)
      session[:history] = session[:history].slice(0, Blacklight::Catalog::SearchHistoryWindow )
    end
  end

end 
