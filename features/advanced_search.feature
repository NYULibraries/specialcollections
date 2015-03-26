Feature: Advanced Search
  In order to be able to quickly locate archival materials of interest
  As an archivist or expert user of archives
  I want an advanced search form.

  Scenario: Advanced search option is available
    Given I am on the default search page
    When I click on the "More options" link
    Then I should see the advanced search form

  Scenario: Advanced search contains correct fields
    Given I am on the advanced search page
    Then I should see the following search fields:
      | All Fields | |
      | Title | |
      | Name | |
      | Subject | |
      | Call No. | |

  Scenario: Advanced keyword search
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup"
    And I submit the search form
    Then I should see search results

  Scenario: Advanced title search
