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

When(/^I clink on the "(.*?)" link$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a pop\-up window labeled "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the pop\-up window should contain the text "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
