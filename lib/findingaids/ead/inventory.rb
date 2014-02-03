# Returns a nested array that represents series and subseries components.  The array conforms to the JSTree format.

module Findingaids::Ead
class Inventory

  attr_accessor :id, :tree, :depth

  def initialize(id)
    @id   = id
    @tree =  Array.new
    solr_query.each do |series|
      @tree << json_node(series)
      @depth = 1
    end
    add_addl_series  
  end

  def add_addl_series
    add_second_level
    add_third_level
    add_fourth_level
  end

  def add_second_level
    self.tree.each do |parent|
      node = Array.new
      solr_query({:parent => parent["metadata"]["ref"]}).each do |series|
        node << json_node(series)
      end
      parent["children"] = node
      @depth = 2 unless node.empty?
    end
  end

  def add_third_level
    self.tree.each do |level1|
      level1["children"].each do |parent|
        node = Array.new
        solr_query({:parent => parent["metadata"]["ref"]}).each do |series|
          node << json_node(series)
        end
        parent["children"] = node
        @depth = 3 unless node.empty?
      end
    end
  end

  def add_fourth_level
    self.tree.each do |level1|
      level1["children"].each do |level2|
        level2["children"].each do |parent|
          node = Array.new
          solr_query({:parent => parent["metadata"]["ref"]}).each do |series|
            node << json_node(series)
          end
          parent["children"] = node
          @depth = 4 unless node.empty?
        end
      end
    end
  end

  def solr_query opts={}
    results = Blacklight.solr.get "select", :params => build_query(opts)
    results["response"]["docs"].collect { |doc| doc }
  end

  def json_node series, node = Hash.new, metadata = Hash.new, attr = Hash.new
    node["data"] = series[Solrizer.solr_name("title", :displayable)]
    metadata["id"] = series["id"]
    metadata["ref"] = series[Solrizer.solr_name("ref", :stored_sortable)]
    metadata["eadid"] = series[Solrizer.solr_name("ead", :stored_sortable)]
    attr["id"] = series["id"]
    node["metadata"] = metadata
    node["attr"] = attr
    return node
  end

  private

  def build_query opts={}, query = Hash.new
    query[:q]    = opts[:parent].nil? ? solr_q_without_parent : solr_q_with_parent(opts[:parent])
    query[:fl]   = solr_fl
    query[:qt]   = ''
    query[:rows] = 10000
    return query
  end

  def solr_q_with_parent parent, params = Array.new
    params << (Solrizer.solr_name("ead", :stored_sortable)+':'+@id+'')
    params << (Solrizer.solr_name("component_children", :type => :boolean)+':TRUE')
    params << (Solrizer.solr_name("parent", :stored_sortable)+':"'+parent+'"')
    return params.join(" AND ")
  end

  def solr_q_without_parent params = Array.new
    params << (Solrizer.solr_name("ead", :stored_sortable)+':'+@id+'')
    params << (Solrizer.solr_name("component_level", :type => :integer)+':1')
    return params.join(" AND ")
  end

  def solr_fl
    [ 
      "id",
      Solrizer.solr_name("component_level", :type => :integer),
      Solrizer.solr_name("parent", :stored_sortable),
      Solrizer.solr_name("title", :displayable),
      Solrizer.solr_name("ref", :stored_sortable),
      Solrizer.solr_name("ead", :stored_sortable)
    ].join(", ")
  end

end
end
