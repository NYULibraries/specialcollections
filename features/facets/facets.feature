Feature: Facets presence and order
  In order to home in on the information I want
  As a researcher
  I want to filter my results in a variety of ways.

  Scenario: See all facets in order
    Given I am on the default search page
    Then I should see facets in the following order:
      | 1 | Library |
      | 2 | Digital Content |
      | 3 | Creator |
      | 4 | Date Range |
      | 5 | Subject |
      | 6 | Name |
      | 7 | Place |
      | 8 | Material Type |
      | 9 | Language |
      | 10 | Collection |
      | 11 | Level |
