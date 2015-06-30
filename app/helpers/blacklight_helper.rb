module BlacklightHelper
  # Make our application helper functions available to core blacklight views
  include ApplicationHelper
  include Blacklight::BlacklightHelperBehavior

  # Change link to document to link out to external guide
  def link_to_document(doc, field, opts={:counter => nil})
    if(doc.unittitle.blank?)
      label=t('blacklight.search.brief_results.link_text.no_title')
    else
      field ||= document_show_link_field(doc)
      label=presenter(doc).render_document_index_label field, opts
    end
    link_to_findingaid(doc, label)
  end

end
