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

When(/^I clink on the "(.*?)" link$/) do |link|
  click_link(link)
end

Then(/^I should see a pop\-up window with the title "(.*?)"$/) do |title|
  expect(find("##{title_to_id_prefix(title)}-modal-label")).to have_content(title)
end

Then(/^the pop\-up window with the title "(.*?)" should contain the text "(.*?)"$/) do |title, text|
  # within("##{title_to_modal_id(title)}") do
  #   expect(page).to have_content(text)
  # end
  # expect(find("#modal-body")).to have_content(text)
  pending
end
