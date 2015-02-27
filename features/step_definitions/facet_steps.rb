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

Then(/^I should see facets in the following order:$/) do |table|
  table.rows_hash.each do |order, value|
    expect(page.find("#facets div.panel-group > div:nth-child(#{order})").text).to eq(value)
  end
end
