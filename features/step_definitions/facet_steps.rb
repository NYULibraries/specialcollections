##
# Faceting steps
Given(/^I (limit|filter) my search to "(.*?)" under the "(.*?)" category$/) do |a, facet, category|
  limit_by_facet(category, facet)
end

When(/^I limit my results to "(.*?)" under the "(.*?)" category$/) do |facet, category|
  limit_by_facet(category, facet)
end

When(/^I hover over the "(.+)" facets$/) do |facet|
  expect(page).to have_text facet
  within(facets_container) do
    link_with_text(facet).hover
  end
end

Then(/^I should see a popover with "(.+)"$/) do |popover_text|
  expect(page).to have_text popover_text
  expect(page).to have_css ".popover", text: popover_text
end

And(/^I should see a "(.*?)" facet under the "(.*?)" category$/) do |facet, category|
  within(facets_container) do
    click_link(category)
    expect(link_with_text(facet)).to have_content
  end
end

Then(/^I should see facets in the following order:$/) do |table|
  table.rows_hash.each do |order, value|
    expect(facets_container.find("div.panel-group > div:nth-child(#{order}) h3 > a").text).to eq(value)
  end
end

Then(/^the limit "(.*?)" should (not )?be selected under the "(.*?)" category$/) do |facet, negator, category|
  if negator
    expect(page.should have_no_selector(:xpath, "//span[@class='facet-label']/span[@class='selected'][text()='#{facet}']"))
  else
    expect(page.find(:xpath, "//span[@class='facet-label']/span[@class='selected'][text()='#{facet}']")).to have_content
  end
end
