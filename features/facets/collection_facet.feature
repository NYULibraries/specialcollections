@berol
Feature: Collection facet
  In order to identify materials of interest within a known collection
  As a researcher
  I want to filter my search results by a "Collection" facet.

  Scenario: Pre limit search by a collection facet
    Given I am on the default search page
    When I limit my search to "Alfred C. Berol Collection of Lewis Carroll" under the "Collection" category
    Then I should see search results

  Scenario: Filter search results by a collection facet
    Given I am on the default search page
    When I search on the phrase "berol"
    And I limit my search to "Alfred C. Berol Collection of Lewis Carroll" under the "Collection" category
    Then I should see search results
