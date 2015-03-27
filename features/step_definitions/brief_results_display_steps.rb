Given(/^I am on the brief results page$/) do
  ensure_root_path
  search_phrase('bloch')
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


When(/^I click on "(.*?)" within css class "(.*?)"/) do |link,class_name|
  within(page.first("dl")) do
    find('a.'"#{class_name}").click
  end
end


Then(/^I should see fields in the following order and value:$/) do |table|
  within(page.first("dl")) do
    save_and_open_page
    table.rows_hash.each do |label, value|
      class_name = get_class_name(label)
      expect(page.find('dt.blacklight-'"#{class_name}")).to have_content "#{label}:"
      expect(page.find('dd.blacklight-'"#{class_name}")).to have_content "#{value}"

    end
  end
end
