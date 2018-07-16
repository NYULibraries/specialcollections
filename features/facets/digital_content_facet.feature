@washsquarephoto
Feature: Digital content facet
  As a researcher I want to filter on results
  that have digital content
  so that I can do research from home.

  Scenario: Filter search results by digital content facet
    Given I am on the default search page
    When I search on the phrase "Washington Square"
    And I limit my search to "Online Access" under the "Digital Content" category
    Then I should see search results
