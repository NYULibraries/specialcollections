module BlacklightHelper
  # Make our application helper functions available to core blacklight views
  include ApplicationHelper
  include Blacklight::BlacklightHelperBehavior

  # Change link to document to link out to external guide
  def link_to_document(doc, field, opts={:counter => nil})
    field ||= document_show_link_field(doc)
    label = presenter(doc).render_document_index_label field, opts

    link_to_findingaid(doc, label)
  end

end
