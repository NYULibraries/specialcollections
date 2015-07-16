Given(/^I am on the brief results page$/) do
  ensure_root_path
  search_phrase('bloch')
end

Then(/^the "(.*?)" field should be "(\d.*?)" characters or less$/) do |label, length|
  expect(documents_list.first.find(:xpath, "//dt[text()='#{label}:']/following-sibling::dd[1]").text.length).to be <= length.to_i
end

Then(/^I should see fields in the following order and value:$/) do |table|
  table.rows_hash.each do |label, value|
    unless label.blank?
      expect(documents_list.first.find(:xpath, "//dt[text()='#{label}:']/following-sibling::dd[1]")).to have_content
    else
      expect(documents_list.first.find(:xpath, "//dd//*[text()='#{value}']")).to have_content
    end
  end
end

When(/^I click on "(.*?)" within the first result$/) do |link_text|
  within("#documents .document:first-child") do
    click_link link_text
  end
end

Then(/^I should see link "(.*?)" within the first result$/) do |link_text|
   expect(documents_list.first).to have_link(link_text)
end

Then(/^I should see text "(.*?)"$/) do |text|
   save_and_open_page
   expect(page).to have_text(text)
end
