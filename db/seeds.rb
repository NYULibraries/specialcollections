# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
require 'authpds'
username = 'dev123'
if Rails.env.development? and User.find_by_username(username).nil?
  user = User.create!({
    username: username, 
    email: 'dev.eloper@library.edu',
  })
  user.save!
end