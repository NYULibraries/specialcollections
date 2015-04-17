module FindingaidsFeatures
  module BookmarksHelper
    def last_email
      ActionMailer::Base.deliveries[-1]
    end
  end
end
