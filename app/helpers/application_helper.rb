module ApplicationHelper

  ##
  # Create url for finding aid
  def url_for_findingaid(repository, eadid, page = nil, anchor = nil)
    page = [page, ENV['FINDINGAIDS_FULL_DEFAULT_EXTENSION']].join(".") unless page.nil?
    return "http://#{ENV['FINDINGAIDS_FULL_HOST']}#{[ENV['FINDINGAIDS_FULL_PATH'], repository, eadid, page].join("/")}#{"#" + anchor unless anchor.nil?}"
  end

  def searching?
    !params[:q].nil? || !params[:f].nil? || params[:commit] == "Search"
  end

  def current_repository
    @current_repository ||= repositories.to_a.select { |repos| repos.last["display"] == params[:repository] }.flatten
  end

  def current_repository_url
    @current_repository_admin_code ||= current_repository.last["url"]
  end

  def current_repository_home_text?
    begin
      I18n.translate!("repositories.#{current_repository_url}.home_text", :raise => true)
    rescue I18n::MissingTranslationData
      false
    rescue NoMethodError
      false
    end
  end

end
