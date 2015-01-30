Given(/^I am on the default search page$/) do
  visit root_path
end

When(/^I perform an empty search$/) do
  ensure_root_path
  search_phrase('')
end

When(/^I search on the phrase "(.*?)"$/) do |phrase|
  ensure_root_path
  search_phrase(phrase)
end

##
# Results steps
Then(/^I should (not )?see search results$/) do |negator|
  if negator
    expect(documents_list).to have_exactly(0).items
  else
    expect(documents_list).to have_at_least(1).items
  end
end

##
# Faceting steps
Given(/^I (limit|filter) my search to "(.*?)" under the "(.*?)" category$/) do |a, facet, category|
  ensure_root_path
  limit_by_facet(category, facet)
end

When(/^I limit my results to "(.*?)" under the "(.*?)" category$/) do |facet, category|
  ensure_root_path
  limit_by_facet(category, facet)
end

And(/^I should see a "(.*?)" facet under the "(.*?)" category$/) do |facet, category|
  within(:css, "#facets") do
    click_link(category)
    expect(page.find(:xpath, "//a[text()='#{facet}']")).to have_content
  end
end

Given(/^I am on the brief results page$/) do
  ensure_root_path
  search_phrase('bloch')
end

# Select a dropdown option
When(/^I select "(.*?)" from the "(.*?)" dropdown$/) do |option, dropdown|
  click_button(dropdown)
  click_link(option)
end

# Check which option is selected in a dropdown
Then(/^the results should be sorted by "(.*?)"$/) do |option|
  find(:css, "#sort-dropdown > button").text.should eq("Sort by #{option}")
end
