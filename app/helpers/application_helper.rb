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
  
  def guide_href(collection, ead_id)
    "http://dlib.nyu.edu/findingaids/html/#{collection}/#{ead_id}"
  end
  
  # Create an excerpt of occurrences in other search fields
  def excerpt_occurrence(field)
    excerpts = Array.new
    field[:document][field[:field]].each do |field_text|
      excerpts << highlight(excerpt(field_text, params[:q]), params[:q]) unless excerpt(field_text, params[:q]).nil?
    end
    return excerpts.join("&mdash;").html_safe
  end
  
  # Highlight the search query within the field
  #
  def highlight_search_text(field)
    if field[:document][field[:field]].is_a? Array
      highlight(field[:document][field[:field]].first.html_safe, params[:q]) 
    else
      highlight(field[:document][field[:field]].html_safe, params[:q])
    end
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
