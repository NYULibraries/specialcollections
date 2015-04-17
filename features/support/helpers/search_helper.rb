module FindingaidsFeatures
  module SearchHelper

    def ensure_root_path
      visit root_path unless current_path == root_path
    end

    def limit_by_facet(category, facet)
      within(:css, '#facets') do
        click_on(category)
        click_on(facet)
      end
    end

    def search_phrase(phrase)
      within(:css, "form.search-query-form") do
        fill_in 'Search...', :with => phrase
      end
      click_button("Search")
    end

    def wait_for_ajax
      Timeout.timeout(Capybara.default_wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery.active').zero?
    end

  end
end
