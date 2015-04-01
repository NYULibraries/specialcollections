module FindingaidsFeatures
  module SearchHelper

    def ensure_root_path
      visit root_path unless current_path == root_path
    end

    def limit_by_facet(category, facet, facets_id = "facets")
      within(:css, "\##{facets_id}") do
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

  end
end
