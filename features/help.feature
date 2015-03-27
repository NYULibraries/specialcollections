Feature: Need Help?
  As an advanced archival user,
  I would like to better understand the type of searches I can perform
  by viewing search tips and
  find information about how to contact repositories.

Scenario: Clicking on the "Search Tips" link brings up the expected dialog
  Given I am on the default search page
  And I see a pane with the title "Need Help?"
  And I see a link "Search Tips" inside the "Need Help?" pane
  When I click on the "Search Tips" link
  Then I should see a pop-up window with the title "Search Tips"
  And the pop-up window should contain the text "'Abraham Lincoln Brigade'"

Scenario: Clicking on the "Special Collections contact information" link brings up the expected dialog
  Given I am on the default search page
  And I see a pane with the title "Need Help?"
  And I see a link "Special Collections contact information" inside the "Need Help?" pane
  When I click on the "Special Collections contact information" link
  Then I should see a pop-up window with the title "Special Collections contact information"
  And the pop-up window should contain the text "New York University Archives and Research Institute for the Study of Man"

