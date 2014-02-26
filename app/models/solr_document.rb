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
  field_semantics.merge!(    
                         :title     => Solrizer.solr_name("title",    :displayable),
                         :author    => Solrizer.solr_name("author",   :displayable),
                         :language  => Solrizer.solr_name("language", :displayable),
                         :format    => Solrizer.solr_name("format",   :displayable),
                         :subject   => Solrizer.solr_name("subject",  :displayable),
                         )
end