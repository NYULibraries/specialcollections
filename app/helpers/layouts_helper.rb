module LayoutsHelper
  def application_title
    t("application_title")
  end

  # Print breadcrumb navigation
  def breadcrumbs
    breadcrumbs = super
    breadcrumbs << link_to_if(link_to_root?, application_title, {:controller =>'catalog', :repository => nil})
    breadcrumbs << controller.controller_name.humanize unless controller.controller_name == "catalog"
    breadcrumbs << link_to_if(searching?, params[:repository], request.path) if params[:repository].present?
    breadcrumbs << "Search" if searching?
    return breadcrumbs
  end

  # Link to logout
  def link_to_logout(params={})
    return unless defined?(logout_url)
    icon_tag(:logout) + link_to("Log-out #{username}".strip, logout_url(params), class: "logout", method: :post)
  end

  # Link to login
  def link_to_login(params={})
    return unless defined?(login_url)
    icon_tag(:login) + link_to("Login", user_nyulibraries_omniauth_authorize_path(params), class: "login", method: :post)
  end

  # Render footer partial
  def footer_html
    render :partial => 'shared/footer'
  end

  # Prepend modal dialog elements to the body
  def prepend_body
    render partial: 'shared/ajax_modal'
  end

  # Prepend search box and flash message partials before to yield
  def prepend_yield
    return unless show_search_box?

    prepend_yield = ""
    prepend_yield = render :partial => 'shared/header_navbar'
    return prepend_yield.html_safe
  end

  # Boolean for whether or not to show tabs
  def show_tabs
    false
  end

  # Only show search box on admin view or for search catalog, excluding bookmarks, search history, etc.
  def show_search_box?
    !controller.controller_name.eql? "bookmarks"
  end

  # Add blacklight body classes to layout
  def body_class
    render_body_class.html_safe
  end

  # Conditionally load left sidebar if we are searching and there are some facets
  def left_sidebar
    controller.controller_name == "catalog" && has_facet_values?
  end

  # Link to root if searching or if on any page that isn't the root
  # /search/catalog
  # /search
  def link_to_root?
    searching? || !["#{ENV['RAILS_RELATIVE_URL_ROOT']}#{search_catalog_path}","#{ENV['RAILS_RELATIVE_URL_ROOT']}#{root_path}"].include?(request.path)
  end

  def gauges_tracking_code
    ENV['GAUGES_TRACKING_CODE']
  end

  def google_analytics_tracking_code
    ENV['GOOGLE_ANALYTICS_TRACKING_CODE']
  end

  def google_tag_manager_tracking_code
    ENV['GOOGLE_TAG_MANAGER_TRACKING_CODE']
  end

  private
end
