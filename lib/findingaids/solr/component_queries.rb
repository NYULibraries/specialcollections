module Findingaids::Solr::ComponentQueries
  extend ActiveSupport::Concern

  # Queries the current solr document for any first-level components, returning either an array of the 
  # documents or nil.
  # 
  # Required: id
  # Options:
  #  - start: If you want the results to start on a specific row; defaults to 0
  #  - rows:  Number of rows to return; defaults to "all" or 10,000
  def first_level_ead_components id, opts={}, docs = Array.new
    solr_response = Blacklight.solr.get "select", :params => first_level_solr_query(id,opts)
    return number_found_from_solr_response(solr_response), docs_from_solr_response(solr_response)
  end

  # Returns the content from a solr field of a given document.
  #
  # Required inputs: String:field, String:id
  # Where *field* is the name of the solr field and *id* is the solr document id.
  def get_field_from_solr id, field
    result = Blacklight.solr.get "select", :params => {:q => 'id:"'+id+'"', :qt => 'document', :fl => field, :rows => 1 }
    result["response"]["docs"].empty? ? nil : result["response"]["docs"].first[field]
  end


  # Query solr for additional ead components that are attached to a given ead document
  #
  # Required:
  #  - id:  The id of the finding aid, ead_id, ex. ARC-0037
  #  - ref: The ref id of the parent component, ref_id, ex. ref1
  # Options: sams as .first_level_ead_components
  def ead_components_from_parent id, ref, opts={}
    solr_response = Blacklight.solr.get "select", :params => additional_solr_query(id,ref,opts)
    return [number_found_from_solr_response(solr_response), docs_from_solr_response(solr_response)]
  end

  private

  def first_level_solr_query id, opts={}
    q = Solrizer.solr_name("component_level", :type => :integer)+':1 AND _query_:"'+Solrizer.solr_name("ead", :stored_sortable)+':'+id+'"'
    Findingaids::Solr::Query.new(q,opts).instance_values
  end

  def additional_solr_query id, ref, opts={}
    q = Solrizer.solr_name("parent", :stored_sortable)+":#{ref} AND "+Solrizer.solr_name("ead", :stored_sortable)+":#{id}"
    Findingaids::Solr::Query.new(q,opts).instance_values
  end

  def docs_from_solr_response solr_response, docs = Array.new
    solr_response["response"]["docs"].collect {|r| r["id"]}.each do |id|
      r, d = get_solr_response_for_doc_id(id)
      docs << d
    end
    return docs
  end

  def number_found_from_solr_response solr_response
    solr_response["response"]["numFound"]
  end

end
