Feature: Cite and Email Bookmarks
  In order to cite and share my research
  As a researcher
  I would like to be able to bookmark records, cite and email them.

  Scenario: Adding a bookmark
    Given I am a logged in user
    And I search on the phrase "Ben Alexrod"
    And I should see search results
    When I check "Bookmark" for the first result
    And I click on the "Your Bookmarks" link
    Then I should see my saved bookmarks
