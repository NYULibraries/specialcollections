Feature: Stable Repository Links
  In order to find primary sources in the holdings of a particular library
  As a user
  I want a stable link to search the holdings of a specific library.

  Scenario: Fales search succeeds for Fales items
    Given I am on the "fales" search page
    When I search "fales" on the phrase "Postal Art Network"
    Then I should see search results

  Scenario: Tamiment search fails for Fales items
    Given I am on the "tamiment" search page
    When I search "tamiment" on the phrase "Postal Art Network"
    Then I should not see search results

  Scenario: Tamiment page selects Tamiment search limit
    Given I am on the "tamiment" search page
    Then I should see results from "The Tamiment Library & Wagner Labor Archives"
    And I should not see results from "The Fales Library & Special Collections"

  Scenario: Fales search selects Fales search limit
    Given I am on the "fales" search page
    Then I should see results from "The Fales Library & Special Collections"
    And I should not see results from "The Tamiment Library & Wagner Labor Archives"
