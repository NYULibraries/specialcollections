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
   	Timeout.timeout(Capybara.default_wait_time) do
      loop until page.evaluate_script('jQuery.active').zero?
    end
end

Then(/^my bookmarks should be saved$/) do
	within(:css,"#bookmarks_nav") do
		find('span', text: "1")
	end
end

Then(/^my bookmarks count should be "(.*?)"$/) do |count|
	within(:css,"#bookmarks_nav") do
		find('span', text: count)
	end
end

When(/^I click on "(.*?)"$/) do |link|
	find('#bookmarks_nav', text: link).click
end

Then(/^I should see bookmarks$/) do
	save_and_open_page
end

When(/^I go to my bookmarks page$/) do
	visit bookmarks_path

	
end

