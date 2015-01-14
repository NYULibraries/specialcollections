FactoryGirl.define do
  factory :solr_response, class: Blacklight::SolrResponse do
    skip_create
    initialize_with { new(data, request_params) }
    data do
      {
        highlighting: { "bytsura" => { :title_ssm => ["The <span class=\"highlight\">Title</span>"] } }
      }
    end
    request_params do
        {
        solr_parameters: {
          qf: "fieldOne^2.3 fieldTwo fieldThree^0.4",
          pf: "",
          spellcheck: 'false',
          rows: "55",
          sort: "request_params_sort"
        }
      }
    end
  end
end
