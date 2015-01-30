module FindingaidsFeatures
  module SearchHelper

    def ensure_root_path
      visit root_path unless current_path == root_path
    end

    def limit_by_facet(category, facet)
      click_on(category)
      if page.has_link? facet
        click_on(facet)
      else
        click_on("more »")
        click_on("A-Z Sort")
        until page.has_link? facet do 
          click_on("Next »")
        end
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
