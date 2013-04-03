# Open up the solr_ead gem class to process ERB in solr.yml
module SolrEad
  class Indexer
    # Creates a new instance of SolrEad::Indexer and connects to your solr server
    # using the url supplied in your config/solr.yml file.
    def initialize(opts={})
      Solrizer.default_field_mapper = EadMapper.new
      if defined?(Rails.root)
        url = YAML.load(ERB.new(File.read(File.join(Rails.root,"config","solr.yml"))).result)[Rails.env]['url']
      elsif ENV['RAILS_ENV']
        url = YAML.load(ERB.new(File.read(File.join(Rails.root,"config","solr.yml"))).result)[ENV['RAILS_ENV']]['url']
      else
        url = YAML.load(ERB.new(File.read("config/solr.yml")).result)['development']['url']
      end
      self.solr = RSolr.connect :url => url
      self.options = opts
    end
  end
end