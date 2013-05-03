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
    link_to("Link to guide", guide_href(field[:document][:repository_s].first, field[:document][field[:field]]), :target => :blank)
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
    solr = RSolr.connect :url => Settings.solr.url
    solr_params = { 
      :qt => '',
      :rows => 10,
      :fl => "score id ead_id ref_id title_display unittitle_t odd_t parent_id_s parent_id",
      :facet => false,
      :hl => true,
      "hl.fl" => "unittitle_t odd_t",
      "hl.simple.pre" => "<span class=\"highlight\">",
      "hl.simple.post" => "</span>",
      "hl.mergeContiguous" => true,
      "hl.fragsize" => 50,
      "hl.snippets" => 10,
      :echoParams => "explicit",
      :qf => "unittitle_t odd_t",
      :pf => "unittitle_t odd_t",
      :defType => "edismax",
      :fq => ["ead_id:#{field[:document]['ead_id']}", "parent_id_s:*"],
      :q => params[:q].split(" ").join(" OR ")
    }
    solr_select = solr.get 'select', :params => solr_params
    unless solr_select["response"]["docs"].empty?
      sub_query_links = []
      solr_select["response"]["docs"].each do |doc| 
        body = solr_select["highlighting"][doc["id"]][field[:field]].join(", ").html_safe
        url = "dsc#{doc["parent_id_s"].first}"
        anchor = doc["parent_id_s"].last if doc["parent_id_s"].is_a? Array and doc["parent_id_s"].count > 1
        sub_query_links << link_to(body, guide_href(field[:document]["repository_s"].first, field[:document]["ead_id"], url, anchor), :target => :blank)
      end
      return sub_query_links
    else
      highlight_search_text(field)
    end
  end
end
