module ApplicationHelper
  
  # Application title
  def application_title
    "Archival Collections"
  end
  
  # Fetch HTML text from field
  def html_field(field)
    field[:document][field[:field]].first.html_safe
  end
  
  # Fetch and link to link field
  def link_field(field)
    link_to("Link to guide", guide_href(field[:document][:repository_s], field[:document][field[:field]]), :target => :blank)
  end
  
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
  
end
