Given(/^I view the catalog index JSON$/) do
  visit search_catalog_path(format: :json)
end

Then(/^I should see valid JSON$/) do
  expect(page).to have_text
  expect(JSON.load(page.text)).to be_present
end
