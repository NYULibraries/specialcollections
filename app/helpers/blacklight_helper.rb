module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Return bool determining if the index field should be shown in the current search results. Show field if:
  # * It's one of the base fields or
  # * A search has been executed and the serach term appears in the field
  def should_show_index_field? document, field, solr_fname
    return true
    return (Findingaids::Ead::Behaviors::DEFAULT_INDEX_FIELDS.include? solr_fname or (!controller.controller_name.eql? "bookmarks" and document.has_highlight_field? solr_fname))
  end
  
  # Change link to document to link out to external guide
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label(doc, opts).html_safe
    label = CGI.unescapeHTML(String.new(label.to_s)).html_safe
    repository = doc[:repository_ssi]
    url = (doc[:parent_ssm].blank?) ? nil : "dsc#{doc[:parent_ssm].first}"
    anchor = doc[:ref_ssi]
    id = doc[:ead_ssi]
    link_to label, url_for_findingaid(repository, id, url, anchor), { :target => "_blank", :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
  end

end