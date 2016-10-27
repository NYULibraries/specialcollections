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
      | 8 | Language |
      | 9 | Collection |
      | 10 | Level |

  Scenario: Facet popover
    Given I am on the default search page
    When I hover over the "Library" facets
    Then I should see a popover with "View materials from one special collection"
