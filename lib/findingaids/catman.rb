module Findingaids::Catman
  extend ActiveSupport::Concern

  include Blacklight::Catalog
  include Findingaids::SolrHelper
  include Findingaids::Solr::ComponentQueries

  # Adds the solr_name method to the catalog controller
  module ClassMethods
    def solr_name(name, *opts)
      Solrizer.solr_name(name, *opts)
    end
  end

  def show_item_within_collection
    ead, id = get_collection_from_item
    redirect_to catalog_path([ead, id]) unless ead.nil?
  end

  def get_component
    if is_collection? and is_component?
      solr_response, document = get_solr_response_for_component_id
      @component = Findingaids::Solr::Component.new(document, solr_response)
    end
  end

  def get_solr_response_for_component_id
    if from_hydra?
      get_solr_response_for_doc_id(params[:ref])
    else
      get_solr_response_for_doc_id(params[:id]+params[:ref])
    end
  end

  def get_component_children
    if is_collection?
      if is_component?
        @numfound, @components = ead_components_from_parent(params[:id], params[:ref]) unless from_hydra?
      else
        @numfound, @components = first_level_ead_components(params[:id])
      end
    end
  end

  private

  def get_collection_from_item
    if params[:id].match("ref")
      ead, id = params[:id].split(/ref/)
      return ead, "ref"+id
    elsif params[:id].match("rrhof")
      ead = get_field_from_solr params[:id], Solrizer.solr_name("ead", :stored_sortable)
      return ead, params[:id]
    end
  end

  def from_hydra?
    params["ref"].match(/^rrhof/) 
  end

  def is_collection?
    params[:id].match(/^ARC/) or params[:id].match(/^RG/) ? true : false
  end

  def is_component?
    params[:ref] ? true : false
  end

end
