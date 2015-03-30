module CitationHelper

  ##
  # Render citation field value
  # hash contains order in which fields should be output for citation
  def render_citation_field(doc)
    display_fields_hsh = {1 => "unittitle_ssm",2 => "unitdate_ssm",3=>"collection_ssm",4=>"unitid_ssm",5=>"location_ssm",6=>"repository_ssi"}
    display_fields_hsh.keys.sort
    cite = []
    display_fields_hsh.each_pair{ |order,solr_name|
      cite << render_index_field_value(:document => doc, :field => solr_name) 
    }

    cite.reject(&:blank?).join("; ").html_safe
  end
end

  