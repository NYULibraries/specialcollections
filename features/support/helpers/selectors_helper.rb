module FindingaidsFeatures
  module SelectorsHelper

    def facets_container
      page.find("#facets")
    end

    def link_with_text(text)
      page.find(:xpath, "//a[text()='#{text}']")
    end

    def documents_list_container
      page.find("#documents")
    end

    def documents_list
      documents_list_container.all(".document")
    end

    def document_container
      page.find("#document")
    end

    def document_field_value(field)
      document_container.find(:xpath, "//dt[text()='#{field}']/following-sibling::dd[1]")
    end

  end
end
