@OH_002
Feature: Date Range facet
  In order to identify which materials are most relevant
  As a researcher
  I want to filter my search results by a "Date Range" facet.

  Scenario: Pre limit search by a Date Range facet
    Given I am on the default search page
    When I limit my search to "1901-2000" under the "Date Range" category
    Then I should see search results

  Scenario: Filter search results by a Date Range facet
    Given I am on the default search page
    When I search on the phrase "radical"
    And I limit my search to "1901-2000" under the "Date Range" category
    Then I should see search results
