# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Application < ActionView::Mustache
      # Meta tags to include in layout
      def meta
        meta = super
        meta << tag(:meta, :name => "HandheldFriendly", :content => "True")
        meta << tag(:meta, 'http-equiv' => "cleartype", :content => "on")
        meta << tag("link", :rel => "search", :type => "application/opensearchdescription+xml", :title =>  application_name, :href => opensearch_catalog_path(:format => 'xml', :only_path => false))
        meta << favicon_link_tag('https://library.nyu.edu/favicon.ico')
        meta << raw(render_head_content)
      end
      
      # Stylesheets to include in layout
      def stylesheets
        catalog_stylesheets
      end

      # Javascripts to include in layout
      def javascripts
        catalog_javascripts
      end

      # Generate link to application root
      def application
        application = link_to application_name, root_path
        application << (params[:controller] == "catalog" and !params[:id]) ? content_tag(:span, t('blacklight.search.search_results'), :id => 'results_text') : ""
      end
      
      # Render the sidebar partial
      def sidebar
        render :partial => 'catalog/sidebar'
      end
      
      # Print breadcrumb navigation
      def breadcrumbs
        breadcrumbs = super
        breadcrumbs << link_to('Catalog', {:controller =>'catalog', :collection => session[:collection]})
        breadcrumbs << link_to('Admin', :controller => 'records') if is_in_admin_view?
        breadcrumbs << link_to_unless_current(controller.controller_name.humanize) unless controller.controller_name.eql? "catalog"
        breadcrumbs << link_to_unless_current(collection_name) unless params[:collection].nil?
        return breadcrumbs
      end
      
      # Render footer partial
      def footer
        render :partial => 'shared/footer'
      end
      
      # Prepend modal dialog elements to the body
      def prepend_body
        prepend_body = '<div class="modal-container"></div>'.html_safe
        prepend_body << '<div id="ajax-modal" class="modal hide fade" tabindex="-1"></div>'.html_safe
      end
      
      # Prepend search box amd flash message partials before to yield
      def prepend_yield
        return unless show_search_box?
        prepend_yield = ""
        
        prepend_yield += render :partial => 'shared/header_navbar' unless is_in_admin_view?
      
        prepend_yield += content_tag :div, :id => "main-flashses" do
         render :partial => '/flash_msg'
        end
        
        return prepend_yield.html_safe
      end
      
      # Boolean for whether or not to show tabs
      def show_tabs
        (!is_in_admin_view? and controller.controller_name.eql? "catalog")
      end
      
      # Only show search box on admin view or for search catalog, excluding bookmarks, search history, etc.
      def show_search_box?
        (is_in_admin_view? or controller.controller_name.eql? "catalog")
      end
  
      # Generate tabs hash from YAML and decide when certain tabs should be selected
      def tabs
        tab_info["views"]["tabs"].collect{|id, values|
          values["id"] = id
          if (!values["url"].nil? and request.path.match values["url"] and values["id"] != "all") or 
              (values["id"] == "all" and (request.path == root_path or request.path == catalog_index_path)) or
                (!session[:collection].nil? and session[:collection].match values["url"])
            values["klass"] = "active"
          end
          values["url"] = (values["url"].match(/^root_path/)) ? values["url"] : root_path + values["url"]
          values["link"] = link_to_with_popover(values["display"], values["url"], values["tip"], "tab")
          values
        }
      end
      alias all_tabs tabs #Need to alias to override parent alias
      
      # Print default blacklight onload code
      def onload
        "$('input#q').focus();" if params[:q].to_s.empty? and params[:f].to_s.empty? and params[:id].nil?
      end
      
      # Add blacklight body classes to laytou
      def body_class
        class_names = render_body_class.html_safe
        class_names << " admin" if is_in_admin_view?        
      end
      
    end
  end
end