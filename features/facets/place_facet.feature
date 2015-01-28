Feature: Place facet
  In order to identify which materials are most relevant
  As a researcher
  I want to filter my search results by a "Place" facet.

  Scenario: Pre limit search by a place facet
    Given I am on the default search page
    When I limit my search to "Spain -- History -- Civil War, 1936-1939 -- Participation, American -- Interviews." under the "Place" category
    Then I should see search results

  Scenario: Filter search results by a place facet
    Given I am on the default search page
    When I search on the phrase "carroll"
    And I limit my search to "Oxford (England)." under the "Place" category
    Then I should see search results


