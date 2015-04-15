Given(/^I am a logged in user$/) do
	@current_user = FactoryGirl.create(:user)
end

And(/^each result should have a "(.*?)"$/) do |term|
  within(:css,"div.document > div.documentHeader > div.documentFunctions") do
	 find('span', text: term)
  end
end

When(/^I check a bookmark$/) do
	check('toggle_bookmark_oh_002ref713')
end

Then(/^my bookmark should be saved$/) do
	within(:css,"#bookmarks_nav") do
		find('span', text: "1")
	end
end

When(/^I check "(.*?)" for the first result$/) do |link|
	within(:css, "#documents .document:first-child") do
		check(link)
		wait_for_ajax
	end
end

Then(/^I should see my saved bookmarks$/) do
	binding.pry
  pending # express the regexp above with the code you wish you had
end
