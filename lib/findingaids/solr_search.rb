module Findingaids
  class SolrSearch

    attr_accessor :solr, :solr_params, :options

    def initialize(opts = {})
      url = Settings.solr.url
      self.solr = RSolr.connect :url => url
      self.options = opts 
    end
    
    def solr_params
      @solr_params ||= { 
        :qt => '',
        :rows => 10,
        :fl => "*",
        :facet => false,
        :hl => true,
        "hl.simple.pre" => "<span class=\"highlight\">",
        "hl.simple.post" => "</span>",
        "hl.mergeContiguous" => true,
        "hl.fragsize" => 50,
        "hl.snippets" => 100,
        :echoParams => "explicit",
        :defType => "edismax"
      }
    end
    
    def solr_select
      solr.get 'select', :params => solr_params
    end

  end
end