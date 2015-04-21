Feature: Language facet
  In order to identify materials of interest within a known collection
  As a researcher
  I want to filter my search results by a "Language" facet.

  Scenario: Pre limit search by a language facet
    Given I am on the default search page
    When I limit my search to "English" under the "Language" category
    Then I should see search results

  Scenario: Filter search results by a collection facet
    Given I am on the default search page
    When I search on the phrase "archive"
    And I limit my search to "English" under the "Language" category
    Then I should see search results
