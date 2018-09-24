Then(/^I should see a (search history|saved searches) link "(.+)"$/) do |title_text, link_text|
  expect(page).to have_text title_text.humanize
  within(".table") do
    expect(page).to have_text link_text
    expect(page).to have_link link_text
  end
end

Then(/^I should see no search history links$/) do
  expect(page).to have_text "Search History"
  expect(page).to_not have_css(".search_history")
end

Then(/^I should see no saved searches links$/) do
  expect(page).to have_text "Saved Searches"
  expect(page).to_not have_css(".table")
end

When(/^I click on the "(.+)" button, accepting the alert "(.+)"$/) do |button_text, alert_text|
  accept_alert alert_text do
    click_on(button_text)
  end
end

Then(/^I should see an alert "(.+)"$/) do |alert_text|
  expect(page).to have_text alert_text
  expect(page).to have_css ".alert", text: alert_text
end
