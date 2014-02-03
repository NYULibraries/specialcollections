module Findingaids::Solr
class Component

  include Blacklight::Solr::Document

  attr_accessor :parents

  def initialize source_doc={}, solr_response=nil
    super
    add_additional_fields if from_hydra?
    add_fields_from_parents unless self[Solrizer.solr_name("parent", :displayable)].nil?
  end

  def add_additional_fields
    result = Blacklight.solr.get "select", :params => additional_fields_query
    self.merge!(result["response"]["docs"].first) { |key, oldval, newval| (newval + oldval).uniq }
  end

  def additional_fields_query
    query = Findingaids::Solr::Query.new 'id:"' + hydra_component_parent_id + '"'
    query.fl = [Solrizer.solr_name("parent_unittitles", :displayable), Solrizer.solr_name("parent", :displayable)]
    query.qt = "document"
    return query.instance_values
  end

  def add_fields_from_parents
    self.parents = Array.new
    self[Solrizer.solr_name("parent", :displayable)].each do |parent_ref|
      self.parents << get_parent_fields(parent_ref)
    end
  end

  def get_parent_fields ref
    result = Blacklight.solr.get "select", :params => parent_fields_query(ref)
    return Findingaids::Solr::Component.new result["response"]["docs"].first, result["response"]
  end

  def parent_fields_query ref
    query = Findingaids::Solr::Query.new 'id:"' + hydra_component_parent_id(ref) + '"'
    query.fl = "*"
    query.qt = "document"
    return query.instance_values
  end

  private

  def from_hydra?
    self.id.match(/^rrhof/) ? true : false
  end

  def hydra_component_parent_id ref=nil
    ref = self.get(Solrizer.solr_name("parent", :stored_sortable)) if ref.nil?
    [self.get(Solrizer.solr_name("ead", :stored_sortable)), ref].join
  end

end
end
