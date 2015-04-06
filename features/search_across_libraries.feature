Feature: Library search field
  In order to search within specific Library collections or across all Libraries
  As a researcher
  I want to have a search field that allows me to limit by Library.

  Scenario: Search is performed across all libraries by default
    Given I am on the default search page
    When I search on the phrase "World War II"
    Then I should see results from "The Fales Library & Special Collections"
    And I should see results from "The Tamiment Library & Robert F. Wagner Labor Archives"

  Scenario: Search scope can be limited to a specific library
    Given I am on the default search page
    When I search on the phrase "World War II"
    Then I should see results from "The Fales Library & Special Collections"
    And I should not see results from "The Tamiment Library & Robert F. Wagner Labor Archives"
