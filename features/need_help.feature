Feature: Need help?
  As an advanced archival users,
  I would like to better understand the type of searches I can perform
  by viewing search tips and
  find information about how to contact repositories.

Scenario: Clicking on the "Search tips" link brings up the expected dialog
  Given I am on the default search page
  And I see a pane with the title "Need help?"
  And I see a link "Search tips" inside the "Need help?" pane
  When I clink on the "Search tips" link
  Then I should see a pop-up window labeled "Search tips"
  And the pop-up window should contain the text "When searching, it's good to keep a few things in mind:"

@wip
Scenario: Clicking on the "Special Collections contact information" link brings up the expected dialog
  Given I am on the default search page
  And I see a pane with the title "Need help?"
  And I see a link "Special Collections contact information" inside the "Need help?" pane
  When I clink on the "Special Collections contact information" link
  Then I should see a pop-up window labeled "Special Collections contact information"
  And the pop-up window should contain the text "New York University Archives and Research Institute for the Study of Man"

