module DocumentHelper
  
  # Render field even if it's an array
  def render_field_name args, results = Array.new
    args[:document][args[:field]].join(",").html_safe
  end

  ## 
  # Render a link to facets
  # Refactor me, please!
  def render_facet_link args, results = Array.new
    return nil unless args
    field = args[:field]
    field_config = args[:field_config]
    document = args[:document]

    if field_config and field_config.highlight and document.has_highlight_field?(field_config.field)
      value = document.highlight_field(field_config.field).map { |x| x.html_safe } if document.has_highlight_field? field_config.field
    else
      begin
        value = document.get(field, :sep => nil) if field
      rescue
        vaule = nil
      end
    end
      
    if value.is_a? Array
      value.each do |text|
        results << facet_link(text, blacklight_config.show_fields[field][:facet])
      end
    elsif value.nil?
      return nil
    else
      results << facet_link(value, blacklight_config.show_fields[field][:facet])
    end

    return results
  end

  # Renders a link for a given term and facet.  The content of term is used for the 
  # text of the link and facet is the solr field to facet on.
  def facet_link term, facet
    link_to term, add_facet_params_and_redirect(facet, Sanitize.clean(term))
  end

  def document_icon doc, result = String.new
    if doc.get(Solrizer.solr_name("format", :displayable)).nil?
      result << "" #image_tag("icons/unknown.png")
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
    repository, anchor, id = doc[:repository_ssi], doc[:ref_ssi], doc[:ead_ssi]
    link_to label, url_for_findingaid(repository, id, path, anchor), { :target => "_blank", :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end

end