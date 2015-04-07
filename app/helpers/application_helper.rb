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

end
