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

And(/^I should see "(.*?)" be "(\d.*?)" characters or less/) do |label,len|
  class_name = get_class_name(label)
  within(page.first("dl")) do
    page.find('dd.blacklight-'"#{class_name}").text.length.should be <= len.to_i
  end
end

And(/^I should see "(.*?)" between "(.*?)" and "(.*?)"/) do |label,field1,field2|
  within(page.first("dl")) do
    f1 = page.find(:xpath, "dt[text()='#{field1}:']/following-sibling::dd[2]").text
    f2 = page.find(:xpath, "dt[text()='#{field2}:']/preceding-sibling::dd[1]").text
    f1.should be == label
    f1.should be == f2
  end
end

Given(/^I choose "(.*?)" as a search scope$/) do |library|
  select "#{library}", :from => "search_field"
end

Then(/^I should see fields in the following order and value:$/) do |table|
  within(page.first("dl")) do
    table.rows_hash.each do |label, value|
      class_name = get_class_name(label)
      expect(page.find('dt.blacklight-'"#{class_name}")).to have_content "#{label}:"
      expect(page.find('dd.blacklight-'"#{class_name}")).to have_content "#{value}"

    end
  end
end
