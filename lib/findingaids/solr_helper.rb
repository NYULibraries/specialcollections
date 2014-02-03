module Findingaids::SolrHelper
  extend ActiveSupport::Concern

  include Blacklight::SolrHelper

  # overide Blacklight::SolrHelper.get_solr_response_for_doc_id to include the current
  # search query for highlighting in the #show view.
  def get_solr_response_for_doc_id(id=nil, extra_controller_params={})
    unless @current_search_session.nil?
      extra_controller_params["hl.q".to_sym] ||= []
      extra_controller_params["hl.q".to_sym] << @current_search_session.query_params[:q]
    end  
    super
  end


end