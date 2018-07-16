@bytsura
Feature: Creator facet
  In order to identify which materials are most relevant
  As a researcher
  I want to filter my search results by a "Creator" facet.

  Scenario: Pre limit search by a creator facet
    Given I am on the default search page
    When I limit my search to "Bytsura, Bill" under the "Creator" category
    Then I should see search results

  Scenario: Filter search results by a creator facet
    Given I am on the default search page
    When I search on the phrase "bill"
    And I limit my search to "Lefferts family" under the "Creator" category
    Then I should see search results
