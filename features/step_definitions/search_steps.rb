Given(/^I am on the default search page$/) do
  visit root_path
end

Given (/^I am on the "(.*)" search page$/) do |place|
 visit "/#{place}"
end

When(/^I perform an empty search$/) do
  ensure_root_path
  search_phrase('')
end

When(/^I search on the phrase "(.*?)"$/) do |phrase|
  ensure_root_path
  search_phrase(phrase)
end

When(/^I search "(.*?)" on the phrase "(.*?)"$/) do |coll, phrase|
  search_phrase(phrase)
end

Given(/^I am on the brief results page$/) do
  ensure_root_path
  search_phrase('bloch')
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

# Select a dropdown option
When(/^I select "(.*?)" from the "(.*?)" dropdown$/) do |option, dropdown|
  click_button(dropdown)
  click_link(option)
end

# Check which option is selected in a dropdown
Then(/^the results should be sorted by "(.*?)"$/) do |option|
  find(:css, "#sort-dropdown > button").text.should eq("Sort by #{option}")
end

##
#Search across libraries steps
Then(/^I should see a label "(.*?)" in the default scope$/) do |label|
  expect(page.find('#search_field').find(:xpath,'option[1]')).to have_content "#{label}"
end

Then(/^I should see results from "(.*?)"$/) do |library|
  within("#documents") do
    page.should have_selector(:link,"#{library}")
  end
end

Then(/^I should not see results from "(.*?)"$/) do |library|
  within("#documents") do
    page.should_not have_selector(:link,"#{library}")
  end
end

Given(/^I choose "(.*?)" as a search scope$/) do |library|
  select "#{library}", :from => "search_field"
end


When(/^I click on the "(.*?)" link$/) do |link|
  click_link link
end

Then(/^I should see the advanced search form$/) do
  expect(page).to have_content "More Search Options"
end

Then(/^I should see the basic search form$/) do
  expect(page.find("form.search-query-form")).to have_content
end

Given(/^I am on the advanced search page$/) do
  visit advanced_search_path
end

Then(/^I should see the following search fields:$/) do |table|
  table.rows_hash.each do |field_title, value|
    expect(page.find_field(field_title)).to have_content
  end
end

When(/^I submit the advanced search form$/) do
  within(:css, "form.advanced") do
    click_button "Search"
  end
end

When(/^I submit the search form$/) do
  click_button "Search"
end

When(/^I fill-in the field "(.*?)" with the term "(.*?)"$/) do |field, value|
  fill_in field, with: value
end

Then(/^I should see exactly (\d+) search result(s)?$/) do |number_of_results, plural|
  expect(documents_list).to have_exactly(number_of_results).items
end

Given(/^I select "(.*?)" from the "(.*?)" attributes dropdown$/) do |value, dropdown|
  within("#advanced_search_facets") do
    click_on(dropdown)
    find('.facet-label', text: /\A#{value}\z/).click
  end
end

# Includes different cases for multiple or single results:
# => Then those results should include: ...
# => Then that result should be: ...
Then(/^(those|that) result(s)? should (include|be):$/) do |pronoun, plural, multiple_state, table|
  table.rows_hash.each do |index, result_title|
    expect(documents_list_container).to have_content result_title
  end
end

Then(/^I should see fields in the following order and value:$/) do |table|
  table.rows_hash.each do |label, value|
      class_name = label.downcase
      expect(documents_list.first.find('dt.blacklight-'"#{class_name}"'_ssm')).to have_content "#{label}:"
      expect(documents_list.first.find('dd.blacklight-'"#{class_name}"'_ssm')).to have_content "#{value}"
  end
end
