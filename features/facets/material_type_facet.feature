Feature: Material Type facet
  In order to identify which types of materials are most relevant
  As a researcher
  I want to filter my search results by a "Material Type" facet.

  Scenario: Pre limit search by a material type facet
    Given I am on the default search page
    When I limit my search to "Clippings (information artifacts)" under the "Material Type" category
    Then I should see search results

  Scenario: Filter search results by a material type facet
    Given I am on the default search page
    When I search on the phrase "bill"
    And I limit my search to "Correspondence." under the "Material Type" category
    Then I should see search results
