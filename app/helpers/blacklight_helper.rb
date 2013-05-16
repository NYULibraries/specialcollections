module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Return bool determining if the index field should be shown in the current search results. Show field if:
  # * It's one of the base fields or
  # * A search has been executed and the serach term appears in the field
  def should_show_index_field? document, field, solr_fname
    return (Findingaids::Document::DEFAULT_INDEX_FIELDS.include? solr_fname or (!controller.controller_name.eql? "bookmarks" and document.has_highlight_field? solr_fname))
  end
  
  # Change link to document to link out to external guide
  # TODO: XSLT in views to create and cache finding aid locally
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts
    link_to(label, url_for_findingaid(doc[:repository_s].first, doc[:ead_id]), {:target => "_blank"}) 
  end
  
end