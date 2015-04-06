module Views
  module Layouts
    class Findingaids < ActionView::Mustache

      def application_title
        t("application_title")
      end

      # Print breadcrumb navigation
      def breadcrumbs
        breadcrumbs = super
        breadcrumbs << link_to_if(searching? || request.path != '/catalog', application_title, {:controller =>'catalog', :repository => nil})
        breadcrumbs << link_to_unless_current(controller.controller_name.humanize) unless controller.controller_name == "catalog"
        breadcrumbs << link_to_if(searching?, params[:repository], request.path) if params[:repository].present?
        breadcrumbs << "Search" if searching?
        return breadcrumbs
      end

      def searching?
        !params[:q].nil? || !params[:f].nil? || params[:commit] == "Search"
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

    end
  end
end
