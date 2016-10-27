class User < ActiveRecord::Base

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks and Folders.
  include Blacklight::User
  devise :omniauthable, omniauth_providers: [:nyulibraries]

end
