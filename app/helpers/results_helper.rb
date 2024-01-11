module ResultsHelper

  ##
  # Render field value, and join as string if it's an array
  def render_field_item(doc)
    doc[:document][doc[:field]].join(", ").truncate(450).html_safe
  end

  ##
  # Render clean faceted link to items in series
  def render_contained_in_links(doc)
    series = doc[:document].parent_unittitles
    collection = doc[:document].collection
    item_title = content_tag(:span, sanitize_html(doc[:document].unittitle), class: "unittitle")

    [link_to_collection(collection), links_to_series(series, collection), item_title].reject(&:blank?).join(" >> ").html_safe
  end

  ##
  # Get a clean link to collection
  def link_to_collection(collection)
    link_to(collection, add_clean_facet_params_and_redirect([collection_facet, collection]))
  end

  ##
  # Get a clean link to all series in array
  def links_to_series(series, collection, links_to_series = [])
    series.each do |ser|
      links_to_series << link_to(ser, add_clean_facet_params_and_redirect([series_facet, ser], [collection_facet, collection]))
    end
    links_to_series
  end

  ##
  # Strip whitespace form field and any HTML that isn't approved
  def sanitize_html(field)
    sanitize(field.strip, tags: %w(strong em)).html_safe
  end

  ##
  # Helper function to determine if collection
  def is_collection?(field_config, doc)
    doc.is_archival_collection?
  end

  ##
  # Helper function to determine if series
  def is_series?(field_config, doc)
    doc.is_archival_series?
  end

  def render_repository_facet_link(doc)
    repository = repositories.find{|key,hash| hash["admin_code"] == doc}
    if !repository
      logger.warn "Could not identify repository for '#{doc}'"
      return doc 
    end
    repository_label repository[1]["url"]
  end

  # This is a bit of a hack to work around the fact that we don't want to change repo names
  # in the source repository folder hierarchy. Since folder names match admin_codes,
  # this looks up the looks up the repo by admin_code and grabs the URL.
  def render_repository_link(doc)
    repos_id = Solrizer.solr_name("repository", :stored_sortable)
    if doc.is_a?(Hash) && doc[:document].to_h.present? && doc[:document][repos_id].present?
      repository = repositories.find{|key,hash| hash["admin_code"] == doc[:document][repos_id]}
      if !repository
        logger.warn "Could not identify repository link for '#{doc}'"
        return "Unknown" 
      end
      link_to_repository(repository[1]["url"]) || "More Unknown"
    end
  end
  
   ##
  # Render clean facet link to parent collection/series
  def render_parent_facet_link(doc)
    if doc[:document].is_archival_collection?
      render_search_within_collection_instructions(doc)
    else
      if doc[:document].is_archival_series?
        render_search_within_series_instructions(doc)
      else (doc[:document].is_archival_object?)
        render_request_item_istructions
      end
    end
  end

  # Render link to collection materials or error message if collection is untitled
  def render_search_within_collection_instructions(doc)
    unless doc[:document].unittitle.blank?
      render_collection_facet_link(doc)
    end
  end

  # Render link to series materials or error message if series is untitled
  def  render_search_within_series_instructions(doc)
    unless doc[:document].unittitle.blank?
      render_series_facet_link(doc)
    else
      content_tag(:span,t('search.brief_results.link_text.no_parents_title.series'),class:"search_within")
    end
  end

  ##
  # Render clean facet link to collection
  def render_collection_facet_link(doc)
    item = doc[:document][doc[:field]].first
    local_params = add_clean_facet_params_and_redirect([collection_facet, item])
    link_to t('search.brief_results.link_text.collection'), local_params, :class => "search_within"
  end

  ##
  #Render clean facet link to series
  def render_series_facet_link(doc)
    collection = doc[:document][doc[:field]].first
    ser = doc[:document][:unittitle_ssm].first
    local_params = add_clean_facet_params_and_redirect([series_facet,ser],[collection_facet,collection])
    link_to t('search.brief_results.link_text.series'),local_params , :class => "search_within"
  end

  ##
  #Render instructions to request item
  def render_request_item_istructions
    item = []
    item << content_tag(:span,t('search.brief_results.link_text.other'),class:"search_within")
    item.join("").html_safe
  end

  # Get icon from format type
  def document_icon(doc)
    doc.normalized_format
  end

  def link_to_repository(repository)
    link_to repository_label(repository), send("#{repository}_path")
  end

  def repository_label(repository)
    repositories[repository]["display"]
  end

  ##
  # Implement blacklight function to add facet parameters into array for redirect
  # but accept array for multiple facets at a time
  def add_clean_facet_params_and_redirect(*fields)
    new_params = reset_facet_params(params)

    fields.each do |field, item|
      new_params = Blacklight::SearchState.new(new_params, blacklight_config).add_facet_params(field, item)
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
    new_params[:controller] = "catalog"
    new_params
  end

  # Shortcut to collection facet name
  def collection_facet
    @collection_facet ||= facet_name("collection")
  end

  # Shortcut to format facet name
  def format_facet
    @format_facet ||= facet_name("format")
  end

  # Shortcut to series facet name
  def series_facet
    @series_facet ||= facet_name("series")
  end

  ##
  # Get solrized name from field
  def facet_name(field)
    Solrizer.solr_name(field, :facetable)
  end

  ##
  # Reset facet parameters to clean search
  def reset_facet_params(source_params)
    Blacklight::Parameters.sanitize(source_params.except(:f)).except(:page, :counter)
  end

end

