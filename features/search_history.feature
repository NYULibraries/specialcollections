@bickceem
Feature: Search history and saved searches
  In order to be able to return to my research uninterrupted
  As a researcher
  I would like to track my search history and saved searches.

  Scenario: Search history starts empty
    Given I am on the default search page
    And I click on the "Search History" link
    Then I should see no search history links

  Scenario: Search appear in search history
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    And I search on the phrase "Kimchi"
    And I click on the "Search History" link
    Then I should see a search history link "Keyword:Ramdasha"
    And I should see a search history link "Keyword:Kimchi"

  Scenario: Clear search history
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    And I search on the phrase "Kimchi"
    And I click on the "Search History" link
    And I click on the "Clear Search History" button, accepting the alert "Clear your search history?"
    Then I should see an alert "Cleared your search history"
    And I should see no search history links

  Scenario: Saved searches start empty
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    And I click on the "Saved Searches" link
    Then I should see no saved searches links

  Scenario: New searches can be added to saved searches
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    And I click on the "Search History" link
    And I click on the "save" button
    Then I should see an alert "Successfully saved your search"
    When I click on the "Saved Searches" link
    Then I should see a saved searches link "Keyword:Ramdasha"

  Scenario: Searches can be deleted from saved searches
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    And I click on the "Search History" link
    And I click on the "save" button
    And I click on the "Saved Searches" link
    And I click on the "delete" button
    Then I should see an alert "Successfully removed that saved search"
    And I should see no saved searches links

  Scenario: Clear saved searches
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    And I click on the "Search History" link
    And I click on the "save" button
    And I click on the "Saved Searches" link
    And I click on the "Clear Saved Searches" button, accepting the alert "Clear your saved searches?"
    Then I should see an alert "Cleared your saved searches"
    And I should see no saved searches links
