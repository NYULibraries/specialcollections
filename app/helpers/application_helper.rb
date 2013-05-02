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
  
  # Highlight search text and link to appropriate page in finding aid
  def highlight_search_text(field)
    # If any of the following fields match, link to admininfo page; otherwise link to the field name page
    link_page = (["custodhist_t","sponsor_t","custodhist_t","acqinfo_t","phystech_t","index_t"].include? field[:field]) ? "admininfo" : field[:field].split("_").first
    # If abstract matches, link to homepage
    link_page = (field[:field].eql? "abstract_t") ? nil : link_page 
    link_body = (field[:document].has_highlight_field? field[:field]) ? field[:document].highlight_field(field[:field]).first.html_safe : field[:document][field[:field]].first.html_safe
    link_to(link_body, guide_href(field[:document]["repository_s"], field[:document]["ead_id"], link_page), :target => :blank)
  end
  
  def search_components(field)
    solr = RSolr.connect :url => Settings.solr.url
    solr_params = { 
      :qt => '',
      :rows => 10,
      :fl => "score ead_id title_t title_display parent_id_s",
      :facet => false,
      :hl => true,
      "hl.fl" => "title_display",
      "hl.simple.pre" => "<span class=\"highlight\">",
      "hl.simple.post" => "</span>",
      "hl.mergeContiguous" => true,
      "hl.fragsize" => 50,
      "hl.snippets" => 10,
      :echoParams => "explicit",
      :qf => "title_t",
      :pf => "title_t",
      :defType => "edismax",
      :fq => ["ead_id:#{field[:document]['ead_id']}", "parent_id:*"],
      :q => params[:q]
    }
    solr_select = solr.get 'select', :params => solr_params
    unless solr_select["response"]["docs"].empty?
      debugger
    end
  end
end
