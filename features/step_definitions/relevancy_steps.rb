Then(/^the document with title "(.*?)" should appear in the "(.*?)" first results$/) do |title, number|
  save_and_open_page("hry")
  solr_docs_titles(documents_list_container).should include(title).in_first(number).results
end

Then(/^the document with title "(.*?)" should appear as first result$/) do |title|
  solr_docs_titles(documents_list_container).should include(title).as_first_result
end
