module FindingaidsFeatures
  module NeedHelpHelper
    def text_to_enclosing_id(text)
      case text
      when 'Need help?'  then 'sidebar'
      when 'Search tips' then 'need_help_links'
      else fail "unrecognized text: #{text}"
      end
    end

    def title_to_modal_id(title)
      case title
      when 'Search tips' then 'search-tips-modal-label'
      else fail "unrecognized title: #{title}"
      end
    end
  end
end
