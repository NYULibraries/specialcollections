Given(/^I am a logged in user$/) do 
	user = FactoryGirl.create(:user)
	user.save!
end

And(/^each result should have a "(.*?)"$/) do |term|
	save_and_open_page
end
