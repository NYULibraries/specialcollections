module ApplicationHelper

  # Link to the finding aid with the passed in label
  def link_to_findingaid(doc, label = nil, opts = {})
    url = get_url_for_findingaid_from_document(doc)
    link_to (label || url), url, opts.merge({ :target => "_blank" })
  end

  # Abstract actually constructing the url to the finding aids document
  def get_url_for_findingaid_from_document(doc)
    # Get pathname if series or component, leave nil if is top level collection
    path = (doc[:parent_ssm].blank?) ? (doc[:format_ssm].first == "Archival Collection") ? nil : "dsc#{doc[:ref_ssi]}" : "dsc#{doc[:parent_ssm].first}"
    anchor = (doc[:parent_ssm].blank?) ? nil : doc[:ref_ssi]
    # Get repository, component ref and EAD id
    repository, eadid = doc[:repository_ssi], doc[:ead_ssi]
    url = url_for_findingaid(repository, eadid, path, anchor)
    # If implied parent structure is correct, use it
    if url_exists?(url)
      return url
    # If not, default to dsc.html with an anchor to the ref id
    else
      return url_for_findingaid(repository, eadid, "dsc", doc[:ref_ssi])
    end
  end

  # Create url for finding aid
  def url_for_findingaid(repository, eadid, page = nil, anchor = nil)
    page = [page, ENV['FINDINGAIDS_FULL_DEFAULT_EXTENSION']].join(".") unless page.nil?
    return "http://#{ENV['FINDINGAIDS_FULL_HOST']}#{[ENV['FINDINGAIDS_FULL_PATH'], repository, eadid, page].join("/")}#{"#" + anchor unless anchor.nil?}"
  end

  # Does the url actually return a valid page
  def url_exists?(url)
    Rails.cache.fetch "url_exists_#{url}", :expires_in => 1.month do
      begin
        Faraday.head(url).status == 200
      rescue
        false
      end
    end
  end

  # Boolean to find out if we are actively searching
  # as opposed to on one of the homepages
  def searching?
    !params[:q].nil? || !params[:f].nil? || params[:commit] == "Search"
  end

  # Get current repository hash from Repositories object based on the param :repository
  def current_repository
    @current_repository ||= repositories.to_a.select { |repos| repos.last["display"] == params[:repository] }.flatten
  end

  # Get the display url for the current repository
  def current_repository_url
    @current_repository_admin_code ||= current_repository.last["url"]
  end

  # All repositories may not have home text associated with their homepage
  # just return false in that case so we know not to render it
  def current_repository_home_text?
    begin
      I18n.translate!("repositories.#{current_repository_url}.home_text", :raise => true)
    rescue
      false
    end
  end

  def maintenance_mode?
    false
  end

  def repositories
    @repositories ||= Findingaids::Repositories.repositories
  end
end
