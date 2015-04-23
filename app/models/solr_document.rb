# -*- encoding : utf-8 -*-
class SolrDocument

  include Blacklight::Solr::Document

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Email )

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Solr::Document::ExtendableClassMethods#field_semantics
  # and Blacklight::Solr::Document#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension( Blacklight::Solr::Document::DublinCore)

  # Turn "Archival Object" to "archival_object"
  def normalized_format
    self[Solrizer.solr_name("format", :displayable)].first.downcase.gsub(/\s/,"_")
  end

  # Print formatted citation
  def export_as_ead_citation_txt
    # Array of citation fields eliminating blank and nil ones
    citation_fields = ["#{"<strong>"+unittitle+"</strong>" if unittitle.present?}", "#{unitdate}","#{collection}", "#{location.gsub(",",";")}", "#{repository}"] - ["",nil]
    citation_fields.join("; ")
  end

  def method_missing(method_id, *args)
    # Allows calling of methods like self.is_arbitrary_format?
    if match = matches_dynamic_format_check?(method_id)
      self.normalized_format == match.captures.first
    # Allow calling of methods like self.unititle
    elsif whitelisted_attributes.include?(method_id)
      attribute = self[Solrizer.solr_name(method_id, :displayable)]
      # If term is plural assume it's an array and treat it as such
      if is_plural?(method_id.to_s)
        (attribute.present?) ? attribute : []
      # If term is singular assume it's a string and treat it as such
      elsif is_singular?(method_id.to_s)
        (attribute.present?) ? attribute.first : ""
      end
    else
      super
    end
  end

  private

  # Is the term singular?
  def is_singular?(term)
    term.singularize == term
  end

  # Is the term plural?
  def is_plural?(term)
    term.pluralize == term
  end

  # Attributes you're allowed to call as instance methods
  def whitelisted_attributes
    @whitelisted_attributes ||= [:unittitle, :unitdate, :collection, :location, :repository, :parent_unittitles]
  end

  ##
  # Check if method_id matches the is_role? schema
  def matches_dynamic_format_check?(method_id)
    /^is_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

end
