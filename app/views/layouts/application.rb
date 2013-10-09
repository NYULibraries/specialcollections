# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Application < ActionView::Mustache
      # Meta tags to include in layout
      def meta
        meta = super
        meta << tag("link", :rel => "search", :type => "application/opensearchdescription+xml", :title =>  application_name, :href => opensearch_catalog_path(:format => 'xml', :only_path => false))
        meta << raw(render_head_content)
      end
      
      def application_title
        t("application_title")
      end
      
      # Print breadcrumb navigation
      def breadcrumbs
        breadcrumbs = super
        breadcrumbs << link_to_unless_current(application_title, {:controller =>'catalog', :repository => nil})
        breadcrumbs << link_to_unless_current(controller.controller_name.humanize) unless controller.controller_name.eql? "catalog"
        breadcrumbs << params[:repository] if params[:repository].present?
        return breadcrumbs
      end
      
      # Render footer partial
      def footer_html
        render :partial => 'shared/footer'
      end
      
      # Prepend modal dialog elements to the body
      def prepend_body
        prepend_body = '<div class="modal-container"></div>'.html_safe
        prepend_body << '<div id="ajax-modal" class="modal hide fade" tabindex="-1"></div>'.html_safe
      end
      
      # Prepend search box and flash message partials before to yield
      def prepend_yield
        return unless show_search_box?
        prepend_yield = ""
        
        prepend_yield += render :partial => 'shared/header_navbar'
      
        prepend_yield += content_tag :div, :id => "main-flashses" do
         render :partial => '/flash_msg'
        end
        
        return prepend_yield.html_safe
      end
      
      # Boolean for whether or not to show tabs
      def show_tabs
        return false
      end
      
      # Only show search box on admin view or for search catalog, excluding bookmarks, search history, etc.
      def show_search_box?
        return (!controller.controller_name.eql? "bookmarks")
      end
  
      # Print default blacklight onload code
      def onload
        "$('input#q').focus();" if params[:q].to_s.empty? and params[:f].to_s.empty? and params[:id].nil?
      end
      
      # Add blacklight body classes to layout
      def body_class
        render_body_class.html_safe    
      end
      
    end
  end
end