@OH_002
Feature: Cite and Email Bookmarks
  In order to cite and share my research
  As a researcher
  I would like to be able to bookmark records, cite and email them.

  Background:
    Given I am logged in
    And I search on the phrase "Ben Alexrod"
    And I should see search results
    And I check "Bookmark" for the first result

  Scenario: Adding a bookmark from brief results
    Given I click on the "Your Bookmarks" link
    Then I should see "Ben Alexrod" saved in my bookmarks

  Scenario: Persisting a bookmark
    Given I search on the phrase "Ben Alexrod"
    Then I should see "In Bookmarks" checked for the first result

  Scenario: Deleting a bookmark from brief results
    Given I uncheck "In Bookmarks" for the first result
    And I click on the "Your Bookmarks" link
    Then I should not see "Ben Alexrod" saved in my bookmarks

  Scenario: Deleting a bookmark from Your Bookmarks
    Given I am on the bookmarks page
    When I uncheck "In Bookmarks" for the first result
    And I reload the page
    Then I should not see "Ben Alexrod" saved in my bookmarks

  Scenario: Citing a bookmark
    Given I am on the bookmarks page
    When I click on the "Cite" button
    Then I should see a popup containing the following citation:
      """
      1. Ben Alexrod, Oct 4, 1979; OH.002; Oral History of the American Left: Radical Histories; Cassette: 391; The Tamiment Library & Robert F. Wagner Labor Archives
      """

      #  Scenario: Emailing a bookmark
      #    Given I am on the bookmarks page
      #    When I click on the "Email" button
      #    And I submit the email form
      #    Then I should receive an email containing a link to the "Ben Alexrod" record
