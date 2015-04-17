module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Change link to document to link out to external guide
  def link_to_document(doc, field, opts={:counter => nil})
    field ||= document_show_link_field(doc)
    label = presenter(doc).render_document_index_label field, opts

    link_to_findingaid(doc, label)
  end

  def link_to_findingaid(doc, label = nil)
    url = get_url_for_findingaid_from_document(doc)
    link_to (label || url), url, { :target => "_blank" }
  end

  def get_url_for_findingaid_from_document(doc)
    # Get pathname if series or component, leave nil if is top level collection
    path = (doc[:parent_ssm].blank?) ? (doc[:format_ssm].first == "Archival Collection") ? nil : "dsc#{doc[:ref_ssi]}" : "dsc#{doc[:parent_ssm].first}"
    anchor = (doc[:parent_ssm].blank?) ? nil : doc[:ref_ssi]
    # Get repository, component ref and EAD id
    repository, eadid = doc[:repository_ssi], doc[:ead_ssi]
    url = url_for_findingaid(repository, eadid, path, anchor)
    if url_exists?(url)
      return url
    else
      return url_for_findingaid(repository, eadid, "dsc", doc[:ref_ssi])
    end
  end

  ##
  # Create url for finding aid
  def url_for_findingaid(repository, eadid, page = nil, anchor = nil)
    page = [page, ENV['FINDINGAIDS_FULL_DEFAULT_EXTENSION']].join(".") unless page.nil?
    return "http://#{ENV['FINDINGAIDS_FULL_HOST']}#{[ENV['FINDINGAIDS_FULL_PATH'], repository, eadid, page].join("/")}#{"#" + anchor unless anchor.nil?}"
  end

  def url_exists?(url)
    Faraday.head(url).status == 200
  end

end
