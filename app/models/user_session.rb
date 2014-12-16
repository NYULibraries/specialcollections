class UserSession < Authlogic::Session::Base
  pds_url(ENV['PDS_URL'] || 'https://logindev.library.nyu.edu')
  calling_system 'findingaids'
  anonymous true
end
