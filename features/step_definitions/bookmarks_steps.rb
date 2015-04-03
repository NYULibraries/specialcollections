Given(/^I am a logged in user$/) do 
	@current_user
end

And(/^each result should have a "(.*?)"$/) do |term|
  within(:css,"div.document > div.documentHeader > div.documentFunctions") do
	 find('span', text: term)
  end
end

When(/^I check a bookmark$/) do 
   	#check('toggle_bookmark_oh_002ref713')
	save_and_open_page
end

