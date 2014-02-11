module ApplicationHelper

  # Create url for finding aid
  def url_for_findingaid(repository, id, page = nil, anchor = nil)
    page = [page, Settings.findingaids.default_extension].join(".") unless page.nil?
    return "http://#{Settings.findingaids.host}#{[Settings.findingaids.path, repository, id, page].join("/")}#{"#" + anchor unless anchor.nil?}"
  end
  
  # Highlight search text and link to appropriate page in finding aid
  def link_to_field(field)
    link_to(highlight(field), url_for_findingaid(field[:document]["repository_s"].first, field[:document]["id"], link_page(field)), :target => "_blank")
  end
  
  # If a match was found in one of the components (i.e. unittitle or odd)
  # do another solr search to get those components and link to those specific pages
  # with anchor tags if applicable
  def link_to_field_or_components(field)
    # Search solr components for specific fields
    components = ComponentSearch.new(field)
    components.solr_select
    
    # If the solr search returned some documents, create the links and send them back
    unless components.has_results?
      link_to_components(components)
    else
      link_to_field(field)
    end
  end
    
  # Loop through component fields found in solr search 
  def link_to_components(components)
    sub_query_links = []
    # Loop through found components
    components.docs.each do |doc| 
      # If a highlighted field was found with the query terms construct the link 
      unless components.highlighting[doc["id"]][components.field_name].nil?
        body = components.highlighting[doc["id"]][components.field_name].join(" ").html_safe
        # Urls to the specific reference pages start with dsc and are followed by the parent reference number
        url = "dsc#{doc["parent_id_s"].first}"
        # The array of parent reference Ids ends with the ref to the anchor
        anchor = doc["parent_id_s"].last if doc["parent_id_s"].is_a? Array and doc["parent_id_s"].count > 1
        sub_query_links << link_to(body, url_for_findingaid(components.repository, components.id, url, anchor), :target => :blank)
      end
    end
    return sub_query_links.join(" ").html_safe
  end
  
  # Which page to link to
  def link_page(field)
    # If any of the following fields match, link to admininfo page; otherwise link to the field name page
    link_page = (Findingaids::EadBehaviors::LINK_FIELDS[:admininfo].include? field[:field]) ? "admininfo" : page_name(field)
    # If abstract matches, link to homepage
    link_page = (Findingaids::EadBehaviors::LINK_FIELDS[:abstract].include? field[:field]) ? nil : link_page 
    # If matches components, it came from the search_components function below, so direct to default dsc page
    link_page = (Findingaids::EadBehaviors::LINK_FIELDS[:dsc].include? field[:field]) ? "dsc" : link_page
    return link_page
  end
  
  # Print highlighted field if exists
  def highlight(field)
    # If this field has a highlighte field, use that version, otherwise use the full field
    (field[:document].has_highlight_field? field[:field] and !controller.controller_name.eql? "bookmarks") ? 
      field[:document].highlight_field(field[:field]).join("...").html_safe : 
        field[:document][field[:field]].join("...").html_safe
  end
  
  # Format page name from solr fields
  def page_name(field)
    field[:field].split("_").first
  end

  def document_icon doc, result = String.new
    if doc.get(Solrizer.solr_name("format", :displayable)).nil?
      result << "" #image_tag("icons/unknown.png")
    else
      filename = doc.get(Solrizer.solr_name("format", :displayable)).downcase.gsub(/\s/,"_")
      result << image_tag("icons/#{filename}.png")
    end
    return result.html_safe
  end

end

