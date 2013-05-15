module ApplicationHelper
  
  # Stylesheets include helper
  def catalog_stylesheets
    catalog_stylesheets = stylesheet_link_tag "http://fonts.googleapis.com/css?family=Muli"
    catalog_stylesheets += stylesheet_link_tag "application"
  end
  
  # Javascripts include helper
  def catalog_javascripts
    catalog_javascripts = javascript_include_tag "application"
  end
  
  # Application title
  def application_title
    t("application_title")
  end
  
  # Form URL for finding aid
  def url_for_findingaid(repository, ead_id, page = nil, anchor = nil)
    "http://dlib.nyu.edu/findingaids/html/#{repository}/#{ead_id}#{"/" + page + ".html" unless page.nil?}#{"#" + anchor unless anchor.nil?}"
  end
  
  # Highlight search text and link to appropriate page in finding aid
  def link_to_field(field)
    link_to(link_body(field), url_for_findingaid(field[:document]["repository_s"].first, field[:document]["ead_id"], link_page(field)), :target => :blank)
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
        sub_query_links << link_to(body, url_for_findingaid(components.repository, components.ead_id, url, anchor), :target => :blank)
      end
    end
    return sub_query_links.join(" ").html_safe
  end
  
  # Which page to link to
  def link_page(field)
    # If any of the following fields match, link to admininfo page; otherwise link to the field name page
    Findingaids::Document::LINK_FIELDS.each do |link_field|
      return link_field[:redirect_to] if link_field[:fields].include? field[:field]
    end
    return field_name(field)
  end
  
  # The text body from which to link
  def link_body(field)
    # If this field has a highlighte field, use that version, otherwise use the full field
    (field[:document].has_highlight_field? field[:field]) ? 
      field[:document].highlight_field(field[:field]).join("...").html_safe : 
        field[:document][field[:field]].join("...").html_safe
  end
  
  def field_name(field)
    field[:field].split("_").first
  end

end

