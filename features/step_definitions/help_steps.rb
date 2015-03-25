Given(/^I see a pane with the title "(.*?)"$/) do |title|
  ensure_root_path
  within(:css, "##{text_to_enclosing_id(title)}") do
    expect(page).to have_content(title)
  end
end

Given(/^I see a link "(.*?)" inside the "(.*?)" pane$/) do |anchor_text, pane_title|
  ensure_root_path
  within(:css, "##{text_to_enclosing_id(pane_title)}") do
    expect(page).to have_content(anchor_text)
  end
end

When(/^I click on the "(.*?)" link$/) do |link|
  click_link(link)
end

Then(/^I should see a pop\-up window with the title "(.*?)"$/) do |title|
  expect(find(:xpath, '//h3[@class="modal-title"]')).to have_content(title)
end

Then(/^the pop\-up window should contain the text "(.*?)"$/) do |text|
  expect(find(:xpath, '//div[@class="modal-body"]')).to have_content(text)
end
