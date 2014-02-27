module DocumentHelper
  
  ##
  # Render field value, and join as string if it's an array
  def render_field_item(args)
    args[:document][args[:field]].join(", ").html_safe
  end
  
  def render_highlighted_field(args)
    link_body(args)
  end
  
  ## 
  # Link to page from table of contents if that field has been indexed and has results
  # This is the only way to ensure that the FA has that page in it
  def link_to_toc_page(doc, label, field)
    content_tag(:dd, link_to(label, url_for_findingaid(doc[:repository_ssi], doc[:ead_ssi], (field == "abstract") ? nil : field), {:target => "_blank"})) if field_has_results_in_document?(doc, field)
  end
  
  ##
  # Find out if the field exists in the returned solr document
  # If this is one of several fields (i.e. admininfo, abstract, dsc) check a handful of subfields which are the items indexed
  # If field is not explicitly defined in LINK_FIELDS hash, then it's legit so just say true
  def field_has_results_in_document?(doc, field)
    if Findingaids::Ead::Behaviors::LINK_FIELDS.has_key?(field.to_sym)
      Findingaids::Ead::Behaviors::LINK_FIELDS[field.to_sym].any? {|fname| doc[Solrizer.solr_name(fname,:displayable)].present? }
    else
      true
    end
  end

  # Change link to document to link out to external guide
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    # Get label
    label = render_document_index_label(doc, opts).html_safe
    # Unescape double escaped entities
    label = CGI.unescapeHTML(String.new(label.to_s)).html_safe
    # Get pathname
    path = (doc[:parent_ssm].blank?) ? "dsc#{doc[:ref_ssi]}" : "dsc#{doc[:parent_ssm].first}"
    anchor = doc[:ref_ssi]
    # Get repository, component ref and EAD id
    repository, eadid = doc[:repository_ssi], doc[:ead_ssi]
    link_to label, url_for_findingaid(repository, eadid, path, anchor), { :target => "_blank" }
  end
  
  # The text body from which to link
  def link_body(field)
    # If this field has a highlighte field, use that version, otherwise use the full field
    (field[:document].has_highlight_field? field[:field]) ? 
      field[:document].highlight_field(field[:field]).join("...").html_safe : 
        field[:document][field[:field]].join("...").html_safe
  end
    
  # Get icon from format type
  def document_icon(doc, result = String.new)
    doc[Solrizer.solr_name("format", :displayable)].first.downcase.gsub(/\s/,"_")
  end
  
  def document_is_collection?(doc)
    doc[Solrizer.solr_name("format", :displayable)].first == "Archival Collection"
  end
  
  def document_is_series?(doc)
    doc[Solrizer.solr_name("format", :displayable)].first == "Archival Series"
  end
  
  def document_is_item?(doc)
    doc[Solrizer.solr_name("format", :displayable)].first == "Archival Item"
  end
  
  def link_to_repository(doc)
    link_to repository_label(doc), eval("#{doc[:repository_ssi]}_path")
  end
  
  def repository_label(doc)
    repositories[doc[:repository_ssi]]["display"]
  end
  
  ##
  # Render clean faceted link to items in series
  def render_series_facet_link(args)
    series = args[:document][args[:field]]
    collection = args[:document][Solrizer.solr_name("collection", :displayable)].first
    links_to_series = []
  
    series.each do |ser|
      links_to_series << link_to(ser, add_clean_facet_params_and_redirect([series_facet, ser],[collection_facet, collection]).merge(sort_by_series))
    end
    [links_to_series].join(" >> ").html_safe
  end
  
  ##
  # Render clean link to components
  def render_components_facet_link(doc)
    add_clean_facet_params_and_redirect([collection_facet, doc[Solrizer.solr_name("collection", :displayable)].first]).merge(sort_by_series)
  end

  ## 
  # Render clean link to components for series
  def render_components_for_series_facet_link(doc)
    collection = doc[Solrizer.solr_name("collection", :displayable)].first
    title = doc[Solrizer.solr_name("title", :displayable)].first
    
    add_clean_facet_params_and_redirect([series_facet, title],[collection_facet, collection]).merge(sort_by_series)
  end

  ##
  # Render clean facet link to just guide
  def render_collection_facet_link(args)
    item = args[:document][args[:field]].first

    local_params = add_clean_facet_params_and_redirect([collection_facet, item],[format_facet,"Archival Collection"])

    link_to args[:document][args[:field]].first, local_params
  end
  
  ##
  # Implement blacklight function to add facet parameters into array for redirect
  # but accept array for multiple facets at a time
  def add_clean_facet_params_and_redirect(*fields)
    new_params = reset_facet_params(params)
    
    fields.each do |field, item|
      new_params = add_facet_params(field, item, new_params)
    end

    # Delete page, if needed. 
    new_params.delete(:page)

    # Delete any request params from facet-specific action, needed
    # to redir to index action properly. 
    Blacklight::Solr::FacetPaginator.request_keys.values.each do |paginator_key| 
      new_params.delete(paginator_key)
    end
    new_params.delete(:id)

    # Force action to be index. 
    new_params[:action] = "index"
    new_params    
  end

  ##
  # Reset facet parameters to clean search
  def reset_facet_params(source_params)
    reset_search_params(source_params.except(:f))
  end
  
  ##
  # Hash with sorting parameters for merging into facet redirect
  def sort_by_series
    {:sort => "#{Solrizer.solr_name("series", :sortable)} asc, #{Solrizer.solr_name("box_filing", :sortable)} asc"}
  end
  
  def collection_facet 
    @collection_facet ||= facet_name("collection")
  end
  
  def format_facet
    @format_facet ||= facet_name("format")
  end
  
  def series_facet
    @series_facet ||= facet_name("series")
  end

  ##
  # Get solrized name from field
  def facet_name(field)
    Solrizer.solr_name(field, :facetable)
  end
  
  ##
  # NOTE: Stole from Blacklight 5, can remove after update
  # Sanitize the search parameters by removing unnecessary parameters
  # from the provided parameters
  # @param [Hash] Hash of parameters
  def sanitize_search_params(source_params)
    my_params = source_params.reject { |k,v| v.nil? }
    my_params.except(:action, :controller, :id, :commit, :utf8)
  end

  ##
  # NOTE: Stole from Blacklight 5, can remove after update
  # Reset any search parameters that store search context
  # and need to be reset when e.g. constraints change
  def reset_search_params(source_params)
    sanitize_search_params(source_params).except(:page, :counter, :q).with_indifferent_access
  end
  
end