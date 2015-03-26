module FindingaidsFeatures
  module HelpHelper
    def text_to_enclosing_id(text)
      case text
      when 'Need help?'  then 'sidebar'
      when 'Search tips' then 'need_help_links'
      when 'Special Collections contact information and hours' then 'need_help_links'
      else fail "unrecognized text: #{text}"
      end
    end
  end
end
