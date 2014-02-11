module DocumentHelper

  def render_external_link args, results = Array.new
    begin
      value = args[:document][args[:field]]
      if value.length > 1
        value.each_index do |index|
          text      = args[:document][blacklight_config.show_fields[args[:field]][:text]][index]
          url       = value[index]
          link_text = text.nil? ? url : text
          results << link_to(link_text, url, { :target => "_blank" }).html_safe
        end
      else
        text      = args[:document].get(blacklight_config.show_fields[args[:field]][:text])
        url       = args[:document].get(args[:field])
        link_text = text.nil? ? url : text
        results << link_to(link_text, url, { :target => "_blank" }).html_safe
      end
    rescue
      return nil
    end
    return results.join(field_value_separator).html_safe
  end
  
  def render_field_name args, results = Array.new
    args[:document][args[:field]].join(",").html_safe
  end

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

  def render_search_link args, results = Array.new
    args[:document][args[:field]].each do |text|
      results << link_to(text, catalog_index_path( :search_field => "all_fields", :q => "\"#{text}\"" ))
    end
    return results.join(field_value_separator).html_safe
  end

  # Presently not used because this is accomplished with SolrMarc at index time using a custom
  # method in a beanshell script.  However, I'm leaving this here in case I change my mind and want
  # it redendered by Rails instead.
  def render_call_number args, results = Array.new
    locations = ["rx", "rhlrr", "rharr", "rhs2", "rhs2o", "rhs3"]
    if args[:document]["marc_ss"]
      MARC::XMLReader.new(StringIO.new(args[:document]["marc_ss"])).first.find_all {|f| f.tag == '945'}.each do |field|
        results << field['a'] if locations.include?(field['l'].strip)
      end
    end
    return results.join(field_value_separator).html_safe
  end

  def document_format_to_filename document = @document
    if document.get(Solrizer.solr_name("format", :displayable)).nil?
      "icons/unknown.png"
    else
      "icons/"+ document.get(Solrizer.solr_name("format", :displayable)).downcase.gsub(/\s/,"_") + ".png"
    end
  end

end