module Findingaids::Solr
class Query

  attr_accessor :q, :fl, :sort, :qt, :rows, :start

  def initialize q, opts = {}
    @q     = q
    @fl    = "id"
    @sort  = sort_fields.join(", ")
    @qt    = "standard"
    @rows  = opts[:rows]  ? opts[:rows]  : Rails.configuration.findingaids_config[:max_components]
    @start = opts[:start] ? opts[:start] : 0
  end 

  def sort_fields
    [
      Solrizer.solr_name("sort", :sortable, :type => :integer) + " asc", 
      Solrizer.solr_name("title", :sortable) + " asc"
    ]
  end

end
end
