Feature: Brief result display
  In order to view relevant fields in search results
  As a researcher
  I want to see relevant fields in the brief search display.

  
  Scenario: Pre limit search by collection
    Given I am on the default search page
    When I search on the phrase "Alfred C. Berol Collection of Lewis Carroll"
    And I limit my search to "Archival Collection" under the "Format" category
    Then I should see fields in the following order and value:
    | Format | Archival Collection |


 