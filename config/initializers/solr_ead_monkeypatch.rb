# Open up the solr_ead gem class to process ERB in solr.yml
module SolrEad
  class Indexer
    attr_accessor :solr_docs
    # Creates a new instance of SolrEad::Indexer and connects to your solr server
    # using the url supplied in your config/solr.yml file.
    def initialize(opts={})
      Solrizer.default_field_mapper = EadMapper.new
      if defined?(ENV['WEBSOLR_URL'])
        url = ENV['WEBSOLR_URL']
      elsif defined?(Rails.root)
        url = YAML.load(ERB.new(File.read(File.join(Rails.root,"config","solr.yml"))).result)[Rails.env]['url']
      elsif ENV['RAILS_ENV']
        url = YAML.load(ERB.new(File.read(File.join(Rails.root,"config","solr.yml"))).result)[ENV['RAILS_ENV']]['url']
      else
        url = YAML.load(ERB.new(File.read("config/solr.yml")).result)['development']['url']
      end
      self.solr_docs = []
      # Retry on 503
      self.solr = RSolr.connect :url => url
      #self.solr = RSolr.connect(:url => url, :retry_503 => 1, :retry_after_limit => 1)
      self.options = opts
    end
    
    # Add multiple documents
    def batch_update(file)
      doc = om_document(File.new(file))
      solr_doc = doc.to_solr
      solr.delete_by_query( 'ead_id:"' + solr_doc["id"] + '"' )
      solr_docs << solr_doc
      add_components(file) unless options[:simple]
    end
    
    #def add_components(file)
    #  counter = 1
    #  components(file).each do |node|
    #    solr_doc = om_component_from_node(node).to_solr(additional_component_fields(node))
    #    solr_doc.merge!({"sort_i" => counter.to_s})
    #    solr_docs << solr_doc
    #    counter = counter + 1
    #  end
    #end
    
    def batch_commit(batch = 500)
      solr_docs.in_groups_of(batch.to_i).each do |solr_docs_arr|
        solr.add solr_docs_arr.delete_if {|x| x.nil? }
      end   
      solr.commit
    end
  end
end
