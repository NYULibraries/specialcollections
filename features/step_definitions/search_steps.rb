Given(/^I am on the default search page$/) do
  visit search_catalog_path
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

##
# Results steps
Then(/^I should (not )?see search results$/) do |negator|
  documents = page.find("#documents").all(".document")
  if negator
    expect(documents).to have_exactly(0).items
  else
    expect(documents).to have_at_least(1).items
  end
end

# Select a dropdown option
When(/^I select "(.*?)" from the "(.*?)" dropdown$/) do |option, dropdown|
  click_button(dropdown)
  click_link(option)
end

# Check which option is selected in a dropdown
Then(/^the results should be sorted by "(.*?)"$/) do |option|
  find("#sort-dropdown > button").text.should eq("Sort by #{option}")
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
  expect(page.find("#documents").all(".document")).to have_exactly(number_of_results).items
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
    expect(page.find("#documents")).to have_content result_title
  end
end

Then(/^I should see the following informational text "(.*?)"$/) do |info_text|
  expect(page.find("p.repository_info")).to have_content info_text
end

Then(/^I should see the following link "(.*?)"$/) do |link_url|
  expect(page.find(:xpath, "//p[@class='repository_info']/span[@class='repository_url']/a[@href='#{link_url}']")).to have_content
end

Then(/^I should see the following text:$/) do |multiline_content|
  multiline_content.split("\n").each do |line_of_text|
    expect(page.find("#content")).to have_content line_of_text
  end
end
