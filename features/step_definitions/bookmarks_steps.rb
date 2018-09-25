And(/^each result should have a "(.*?)"$/) do |term|
  within(:css,"div.document > div.documentHeader > div.documentFunctions") do
	 find('span', text: term)
  end
end

Then(/^my bookmark should be saved$/) do
	within(:css,"#bookmarks_nav") do
		find('span', text: "1")
	end
end

When(/^I (un)?check "(.*?)" for the first result$/) do |negator,link|
	within(:css, "#documents .document:first-child") do
    (negator) ? uncheck(link) : check(link)
		wait_for_ajax
	end
end

Then(/^I should (not )?see "(.*?)" saved in my bookmarks$/) do |negator, bookmark|
  if negator
    expect(page).to have_content "You have no bookmarks"
  else
    expect(find("#documents .document:first-child .index_title a").text).to eql bookmark
  end
end

Then(/^I should see "In Bookmarks" checked for the first result$/) do
  expect(find("#documents .document:first-child input.toggle_bookmark:checked")).to have_content
end

Given(/^I see "In Bookmarks" checked for the first result$/) do
  expect(find("#documents .document:first-child")).to have_content
end

Given(/^I am on the bookmarks page$/) do
  visit bookmarks_path
end

When(/^I reload the page$/) do
  visit current_url
end

When(/^I submit the email form$/) do
  within("#email_form") do
    fill_in "Email:", with: "lib-webservices@nyu.edu"
    fill_in "Message:", with: "Check out these wicked awesome bookmarks"
    click_on "Send"
  end
  expect(page).to have_no_text "Email This"
end

Then(/^I should see a popup containing the following citation:$/) do |string|
  expect(page.find("#ajax-modal .modal-content").text).to have_content
end

Then(/^I should receive an email containing a link to the "(.*?)" record$/) do |record_title|
  record_url = last_email.body.raw_source.split("\n")[1].gsub(/URL: /,"")
  expect(find("#documents .document:first-child .index_title a")[:href]).to eql record_url
end
