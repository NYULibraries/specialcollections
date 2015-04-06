module FindingaidsFeatures
  module RelevancyHelper
    def solr_docs_titles(documents_list_container)
      @solr_docs_titles= []
      documents_list_container.all(:xpath, '//dd[@class="blacklight-unittitle_ssm"]').each do |solr_doc|
        @solr_docs_titles << solr_doc.text
      end
      @solr_docs_titles
    end
  end
end
