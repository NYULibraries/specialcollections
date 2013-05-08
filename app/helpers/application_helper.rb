module ApplicationHelper
  
  # Application title
  def application_title
    "Archival Collections"
  end
  
  # Form URL for finding aid
  def guide_href(collection, ead_id, page = nil, anchor = nil)
    "http://dlib.nyu.edu/findingaids/html/#{collection}/#{ead_id}#{"/" + page + ".html" unless page.nil?}#{"#" + anchor unless anchor.nil?}"
  end

  # Stylesheets include helper
  def catalog_stylesheets
    catalog_stylesheets = stylesheet_link_tag "http://fonts.googleapis.com/css?family=Muli"
    catalog_stylesheets += stylesheet_link_tag "application"
  end
  
  # Javascripts include helper
  def catalog_javascripts
    catalog_javascripts = javascript_include_tag "application"
  end
  
  # Highlight search text and link to appropriate page in finding aid
  def highlight_search_text(field)
    link_to(link_body(field), guide_href(field[:document]["repository_s"].first, field[:document]["ead_id"], link_page(field), link_anchor(field)), :target => :blank)
  end
  
  # Which page to link to
  def link_page(field)
    # If any of the following fields match, link to admininfo page; otherwise link to the field name page
    link_page = (["custodhist_t","sponsor_t","custodhist_t","acqinfo_t","phystech_t","index_t"].include? field[:field]) ? "admininfo" : field[:field].split("_").first
    # If abstract matches, link to homepage
    link_page = (field[:field].eql? "abstract_t") ? nil : link_page 
    # If matches odd or unittitle, it came from the search_components function below, so direct to default dsc page
    link_page = (["odd_t","unittitle_t"].include? field[:field]) ? "dsc" : link_page
    return link_page
  end
  
  # The text body from which to link
  def link_body(field)
    # If this field has a highlighte field, use that version, otherwise use the full field
    (field[:document].has_highlight_field? field[:field]) ? 
      field[:document].highlight_field(field[:field]).join("...").html_safe : 
        field[:document][field[:field]].join("...").html_safe
  end
  
  # The page anchor for linking, if any
  def link_anchor(field)
    nil
  end
  
  # If a match was found in one of the components (i.e. unittitle or odd)
  # do another solr search to get those components and link to those specific pages
  # with anchor tags if applicable
  def search_components(field)
    # Search solr components for specific fields
    solr_search = Findingaids::ComponentSearch.new(field)
    
    # If the solr search returned some documents, create the links and send them back
    unless solr_search.has_results?
      highlight_component_fields(solr_search)
    else
      highlight_search_text(field)
    end
  end
    
  # Loop through component fields found in solr search 
  def highlight_component_fields(solr_search)
    sub_query_links = []
    # Loop through found components
    solr_search.docs.each do |doc| 
      # If a highlighted field was found with the query terms construct the link 
      unless solr_search.highlighting[doc["id"]][solr_search.solr_field_name].nil?
        body = solr_search.highlighting[doc["id"]][solr_search.solr_field_name].join(" ").html_safe
        # Urls to the specific reference pages start with dsc and are followed by the parent reference number
        url = "dsc#{doc["parent_id_s"].first}"
        # The array of parent reference Ids ends with the ref to the anchor
        anchor = doc["parent_id_s"].last if doc["parent_id_s"].is_a? Array and doc["parent_id_s"].count > 1
        sub_query_links << link_to(body, guide_href(solr_search.repository, solr_search.ead_id, url, anchor), :target => :blank)
      end
    end
    return sub_query_links.join(" ").html_safe
  end

end

