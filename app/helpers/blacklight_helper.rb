module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Change link to document to link out to external guide
  def link_to_document(doc, field, opts={:counter => nil})
    field ||= document_show_link_field(doc)
    label = presenter(doc).render_document_index_label field, opts

    # Get pathname if series or component, leave nil if is top level collection
    path = (doc[:parent_ssm].blank?) ? (doc[:format_ssm].first == "Archival Collection") ? nil : "dsc#{doc[:ref_ssi]}" : "dsc#{doc[:parent_ssm].first}"
    anchor = (doc[:parent_ssm].blank?) ? nil : doc[:ref_ssi]
    # Get repository, component ref and EAD id
    repository, eadid = doc[:repository_ssi], doc[:ead_ssi]
    link_to label, url_for_findingaid(repository, eadid, path, anchor), { :target => "_blank" }
  end

end
