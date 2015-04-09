Feature: Subject facet
  In order to identify which materials are most relevant
  As a researcher
  I want to filter my search results by a "Subject" facet.

  Scenario: Pre limit search by a subject facet
    Given I am on the default search page
    When I limit my search to "African American radicals -- Interviews." under the "Subject" category
    Then I should see search results

  Scenario: Filter search results by a name facet
    Given I am on the default search page
    When I search on the phrase "Broadcasting"
    And I limit my search to "African American radicals -- Interviews." under the "Subject" category
    Then I should see search results
