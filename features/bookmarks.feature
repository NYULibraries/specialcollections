Feature: Cite and Email Bookmarks
  As a logged in user,
  I would like to bookmark certain records
  and be able to share them 
  by citing and emailing them.

@bm
Scenario: Clicking on "Bookmark" saves the bookmark
  Given I am a logged in user
  When I search on the phrase "Ben Alexrod"
  Then I should see search results 
  And each result should have a "Bookmark"
  


