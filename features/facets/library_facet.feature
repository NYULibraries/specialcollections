@oconor
Feature: Library facet
  In order to find the most relevant results
  As a researcher
  I want to filter my search results by a "Library" facet.

  Scenario: Pre limit search by a library facet
    Given I am on the default search page
    When I limit my search to "The Fales Library & Special Collections" under the "Library" category
    Then I should see search results

  Scenario: Filter search results by a library facet
    Given I am on the default search page
    When I search on the phrase "presidents"
    And I limit my search to "The Fales Library & Special Collections" under the "Library" category
    Then I should see search results
