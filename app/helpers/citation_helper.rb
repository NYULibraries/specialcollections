module CitationHelper

  ##
  # Render citation field value
  # hash contains order in which fields should be output for citation
  def render_citation_field(doc)
    display_fields_hsh = { 1 =>  Solrizer.solr_name("unittitle",  :displayable),
                           2 =>  Solrizer.solr_name("unitdate",   :displayable),
                           3 =>  Solrizer.solr_name("collection", :displayable),
                           4 =>  Solrizer.solr_name("unitid", :displayable),
                           5 =>  Solrizer.solr_name("location", :displayable),
                           6 =>  Solrizer.solr_name("repository", :stored_sortable),
                           7 =>  Solrizer.solr_name("address", :searchable)
                        }
    display_fields_hsh.keys.sort
    cite = []
    cite_title = ""
    display_fields_hsh.each_pair{ |order,solr_name|
      cite << render_index_field_value(:document => doc, :field => solr_name) unless doc[solr_name].blank?
    }
    # Need comma after title according to user story
    if doc[Solrizer.solr_name("unittitle",  :displayable)]
      title = cite.slice!(0) 
      title = "#{title}, "
    end

    # rest of the fields should be separated by a semi colon
    [title,cite.reject(&:blank?).join("; ")].join("").html_safe
  end
end

  