module ApplicationHelper
  
  # Fetch and link to link field
  def link_field(field)
    link_to("Link to resource", field[:document][field[:field]], :target => :blank)
  end
  
  # Fetch HTML text from field
  def html_field(field)
    field[:document][field[:field]].first.html_safe
  end
  
  # Generate link to sorting action
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    direction_icon = (direction.eql? "desc") ? :sort_desc : :sort_asc
    search = params[:search]  
    html = link_to title, params.merge(:sort => column, :direction => direction, :page => nil, :id => ""), {:class => css_class}
    html << icon_tag(direction_icon) if column == sort_column
    return html
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
  
  # Will output HTML pagination controls. Modeled after blacklight helpers/blacklight/catalog_helper_behavior.rb#paginate_rsolr_response
  # Equivalent to kaminari "paginate", but takes a Sunspot response as first argument. 
  # Will convert it to something kaminari can deal with (using #paginate_params), and
  # then call kaminari page_entries_info with that. Other arguments (options and block) same as
  # kaminari paginate, passed on through. 
  def page_entries_info_sunspot(response, options = {}, &block)
    per_page = response.results.count
    per_page = 1 if per_page < 1
    current_page = (response.results.offset / per_page).ceil + 1
    page_entries_info Kaminari.paginate_array(response.results, :total_count => response.total).page(current_page).per(per_page), options, &block
  end

  # Retrieve a value matching a key to an icon class name
  def icons key
    icons_info[key.to_s]
  end
  
  # Load the icons YAML info file
  def icons_info
    @icons_info ||= YAML.load_file( File.join(Rails.root, "config", "icons.yml") )
  end
  
  # Generate a tooltip tag
  def tooltip_tag content, title
    link_to(content, "#", :class => "help-inline record-help", :data => { :placement => "right" }, :rel => "tooltip", :target => "_blank", :title => title)
  end
  
  # Generate an icon tag with class key
  def icon_tag key
    content_tag :i, "", :class => icons(key)
  end
  
  def delayed_jobs_running?
    (Delayed::Job.count > 0)
  end
  
end
