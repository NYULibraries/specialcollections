module ApplicationHelper

  ##
  # Create url for finding aid
  def url_for_findingaid(repository, eadid, page = nil, anchor = nil)
    page = [page, Settings.findingaids.default_extension].join(".") unless page.nil?
    return "http://#{Settings.findingaids.host}#{[Settings.findingaids.path, repository, eadid, page].join("/")}#{"#" + anchor unless anchor.nil?}"
  end
  
end

