Then(/^the document with title "(.*?)" should appear in the first "(.*?)" results$/) do |title, number|
  n = number.to_i - 1 rescue document_titles.count
  expect(document_titles[0..n]).to include title
end

Then(/^the document with title "(.*?)" should appear as the first result$/) do |title|
  expect(document_titles.first).to eql title
end
