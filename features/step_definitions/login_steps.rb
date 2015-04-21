Given(/^I am logged in$/) do
end

Then(/^I should see "Log-out"$/) do
  within(:css, "ol.nyu-breadcrumbs > li.nyu-login") do
    expect(page).to have_content("Log-out")
  end
end
