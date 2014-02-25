module DocumentHelper
  
  ##
  # Render field value, and join as string if it's an array
  def render_field_name args
    join_by = args[:field] == Solrizer.solr_name(:parent_unittitles, :displayable) ? " >> " : ", "
    args[:document][args[:field]].join(join_by).html_safe
  end
  
  def render_highlighted_field args
    
  end

  # Renders a link for a given term and facet.  The content of term is used for the 
  # text of the link and facet is the solr field to facet on.
  def facet_link term, facet
    #link_to term, add_facet_params_and_redirect(facet, Sanitize.clean(term))
  end
  
  def render_collection_facet_link args
    #params.reject! {|k,v| ["q","f"].include? k }
    #params.merge!({"f"=>{Solrizer.solr_name("collection", :facetable)=>args[:document][args[:field]], Solrizer.solr_name("format", :facetable)=>["Archival Collection"]}})
    #params = reset_search_params(params) unless params.nil?
    #link_to args[:document][args[:field]].first, params
  end

  def document_icon doc, result = String.new
    if doc.get(Solrizer.solr_name("format", :displayable)).nil?
      result << ""
    else
      filename = doc.get(Solrizer.solr_name("format", :displayable)).downcase.gsub(/\s/,"_")
      result << image_tag("icons/#{filename}.png", :class => "icon_image")
    end
    return result.html_safe
  end

  # Change link to document to link out to external guide
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    # Get label
    label = render_document_index_label(doc, opts).html_safe
    # Unescape double escaped entities
    label = CGI.unescapeHTML(String.new(label.to_s)).html_safe
    # Get pathname
    path = (doc[:parent_ssm].blank?) ? nil : "dsc#{doc[:parent_ssm].first}"
    # Get repository, component ref and EAD id
    repository, anchor, eadid = doc[:repository_ssi], doc[:ref_ssi], doc[:ead_ssi]
    link_to label, url_for_findingaid(repository, eadid, path, anchor), { :target => "_blank", :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end
  
  ##
  # Sanitize the search parameters by removing unnecessary parameters
  # from the provided parameters
  # @param [Hash] Hash of parameters
  def sanitize_search_params source_params

    my_params = source_params.reject { |k,v| v.nil? }

    my_params.except(:action, :controller, :id, :commit, :utf8)
  end

  ##
  # Reset any search parameters that store search context
  # and need to be reset when e.g. constraints change
  def reset_search_params source_params
    sanitize_search_params(source_params).except(:page, :counter).with_indifferent_access
  end

end