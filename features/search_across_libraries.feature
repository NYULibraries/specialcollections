Feature: Search across all libraries
  As a researcher, I want to be able to search across all libraries
  so that I don't need to know the specific focus of a particular library.

  Scenario: default search scope is labeled "All Libraries"
    Given I am on the default search page
    Then I should see a label "All Libraries" in the default scope
 
  Scenario: search is performed across all libraries by default
    Given I am on the default search page
    And I search on the phrase "World War || "
    Then I should see results from "The Fales Library & Special Collections" and from "The Tamiment Library & Robert F. Wagner Labor Archives"
