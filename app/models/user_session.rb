class UserSession < Authlogic::Session::Base
  pds_url Settings.login.pds_url
  calling_system Settings.login.calling_system
  anonymous true
  
  def additional_attributes
    h = {}
    return h unless pds_user
    h[:findingaids_admin], h[:findingaids_admin_collections] = true, ["global"] if Settings.login.default_admins.include? pds_user.uid
    return h
  end
end