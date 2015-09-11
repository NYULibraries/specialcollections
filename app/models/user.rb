class User < ActiveRecord::Base
  # Connects this user object to Blacklights Bookmarks and Folders.
  include Blacklight::User
  devise :omniauthable, omniauth_providers: [:nyulibraries]

end
