##
# ComponentSearch performs a Solr search after one of the component fields has already been found by Blacklight
#
# Searches solr for only child elements, i.e. components, of the EAD found in a general keyword search at the top level
# Find specific components for linking found instances of a full text query of unittitle_t odd_t fields
class ComponentSearch

  attr_reader :solr, :solr_reponse, :rows
  attr_accessor :solr_params

  # Setup Solr connection and initiate search
  def initialize(solr_reponse)
    @solr = RSolr.connect :url => Settings.solr.url
    @solr_reponse = solr_reponse
    @rows = 10
  end
  
  # Default solr parameters for searching components
  def solr_params
    @solr_params ||= { 
      :qt => '',
      :defType => "edismax",
      :rows => rows,
      :facet => false,
      :hl => true,
      "hl.simple.pre" => "<span class=\"highlight\">",
      "hl.simple.post" => "</span>",
      "hl.mergeContiguous" => true,
      "hl.fragsize" => 50,
      "hl.snippets" => 100,
      :echoParams => "explicit",
      :ps => 50,
      :fq => ["ead_id:#{ead_id}", "parent_id_s:*"], 
      :q => q, 
      :fl => "score id ead_id ref_id title_display unittitle_t odd_t parent_id_s parent_id",
      "hl.fl" => component_qf,
      :qf => component_qf,
      :pf => component_qf
    }
  end
  
  # Search Solr
  def solr_select
    @solr_select ||= solr.get 'select', :params => solr_params
  end
  
  # Did solr search return results?
  def has_results
    @has_results ||= solr_select["response"]["docs"].empty?
  end
  alias_method :has_results?, :has_results
  
  # Return the solr documents from the search
  def docs
    @docs ||= solr_select["response"]["docs"]
  end
  
  # Return the highlighting from the solr search
  def highlighting
    @highlighting ||= solr_select["highlighting"]
  end
  
  # Field name matched in the component
  def field_name
    @field_name ||= solr_reponse[:field]
  end
  
  # ID for the matched EAD
  def ead_id
    @ead_id ||= solr_reponse[:document]["ead_id"]
  end
  
  # Repository for the matched EAD
  def repository
    repository ||= solr_reponse[:document]["repository_s"].first
  end

  protected
      
  # Query terms matched in original search,
  # Formatted here to match in component search
  def q
    @q ||= solr_reponse[:document].solr_response["responseHeader"]["params"]["q"].split(" ").join(" OR ")
  end
   
  # Fields in the component to search
  def component_qf
    @component_search_fields ||= "unittitle_t odd_t"
  end

end
