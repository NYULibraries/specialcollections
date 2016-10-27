module FindingaidsFeatures
  module SearchHelper

    def ensure_root_path
      visit root_path unless current_path == root_path
    end

    def limit_by_facet(category, facet, facets_id = "facets")
      within(:css, "\##{facets_id}") do
        click_on(category) unless category == "Library"
        find("a", text: facet).hover
        click_on(facet)
      end
    end

    def search_phrase(phrase)
      within(:css, "form.search-query-form") do
        fill_in "q", :with => phrase
      end
      click_button("Search")
    end


    def get_class_name(label)
      class_hsh = { "Format"       =>  Solrizer.solr_name("format", :displayable),
                    "Date range"   =>  Solrizer.solr_name("unitdate", :displayable),
                    "Abstract"     =>  Solrizer.solr_name("abstract", :displayable),
                    "Library"      =>  Solrizer.solr_name("repository", :stored_sortable),
                    "Call no"      =>  Solrizer.solr_name("unitid", :displayable),
                    "Location"     =>  Solrizer.solr_name("location", :displayable),
                    "Contained in" =>  Solrizer.solr_name("heading", :displayable)
                  }

      class_hsh[label]
    end

    def wait_for_ajax
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery.active').zero?
    end

  end
end
