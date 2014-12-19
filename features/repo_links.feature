Feature: Stable Repository Links
  In order to find primary sources in the holdings of a particular library
  And to share with my students as part of their assignment
  As an NYU faculty member
  I want a stable link to search the holdings of a specific library.

  Scenario: Fales search succeeds for Fales items
    Given I am on the "fales" search page
    When I search on the phrase "Postal Art Network"
    Then I should see search results

  Scenario: Tamiment search fails for Fales items
    Given I am on the "tamiment" search page
    When I search on the phrase "Postal Art Network"
    Then I should not see search results

  Scenario: Tamiment page selects Tamiment search limit
    Given I am on the "tamiment" search page
    Then "The Tamiment Library & Robert F. Wagner Labor Archives" should be selected for "search_field"

  Scenario: Fales search selects Fales search limit
    Given I am on the "fales" search page
    Then "The Fales Library & Special Collections" should be selected for "search_field"