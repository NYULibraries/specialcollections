module FindingaidsFeatures
  module HelpHelper
    def text_to_enclosing_id(text)
      case text
      when 'Need Help?'  then 'sidebar'
      else fail "unrecognized text: #{text}"
      end
    end
  end
end
