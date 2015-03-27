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

    def get_class_name(label)
      class_hsh = {"Format" => "format_ssm", 
                   "Date range" => "unitdate_ssm", 
                   "Abstract" => "abstract_ssm", 
                   "Library" => "repository_ssi", 
                   "Call no" => "unitid_ssm",
                   "Location" => "location_ssm",
                   "Contained in" => "heading_ssm"
                    }

      
      class_hsh[label]
    end

  end
end
