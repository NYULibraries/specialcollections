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
      | Call No. | |
      | Collection | |

  Scenario: Advanced keyword search
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup"
    And I submit the search form
    Then I should see exactly 2 search results
    And those results should include:
      | 1 | Bill Bytsura ACT UP Photography Collection |
      | 2 | September 16, 1991 [Ann Northup, Stop Forced HIV Testing] |

  Scenario: Advanced keyword search pre-selecting Archival Collections only
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup"
    And I select "Archival Collection" from the "Format" attributes dropdown
    And I submit the search form
    Then I should see exactly 1 search result
    And that result should be:
      | 1 | Bill Bytsura ACT UP Photography Collection |

  Scenario: Advanced title search
    Given I am on the advanced search page
    When I fill-in the field "Title" with the term "Northup"
    And I submit the search form
    Then I should see exactly 1 search result
    And that result should be:
      | 1 | September 16, 1991 [Ann Northup, Stop Forced HIV Testing]|

  Scenario: Advanced keyword search pre-selecting Archival Series only
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup"
    And I select "Archival Series" from the "Format" attributes dropdown
    And I submit the search form
    Then I should see exactly 0 search results

  @wip
  Scenario: Advanced AND boolean keyword search
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup AND Randy"
    And I submit the search form
    Then I should see exactly 1 search result
    And that result should be:
      | 1 | Bill Bytsura ACT UP Photography Collection |

  @wip
  Scenario: Advanced OR boolean keyword search
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup OR Fleck"
    And I submit the search form
    Then I should see exactly 3 search results
    And those results should include:
      | 1 | Bill Bytsura ACT UP Photography Collection |
      | 2 | September 16, 1991 [Ann Northup, Stop Forced HIV Testing] |
      | 2 | Fleck, Dave |

  @wip
  Scenario: Advanced NOT boolean keyword search
    Given I am on the advanced search page
    When I fill-in the field "All Fields" with the term "Northup NOT Randy"
    And I submit the search form
    Then I should see exactly 1 search result
    And that result should be:
      | 1 | September 16, 1991 [Ann Northup, Stop Forced HIV Testing] |
