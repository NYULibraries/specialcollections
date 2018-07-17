@bickceem @heti @bartlett @oconor
Feature: Enhanced search relevancy
  In order to get the most relevant materials
  As a researcher
  I expect the search tool to know which fields should be weighted higher.

  Scenario: Documents with matching 'unit title' for collection should be weighted highest
    Given I am on the default search page
    When I search on the phrase "Ramdasha"
    Then the document with title "Ramdasha Bikceem Riot Grrrl Collection" should appear as the first result

  Scenario: Documents with matching 'abstract' should be weighted high
    Given I am on the default search page
    When I search on the phrase "How Should a Person Be ?"
    Then the document with title "Sheila Heti Riot Grrrl Collection" should appear in the first "5" results

  Scenario: Documents with matching 'creator' should appear at the begining of the search results
    Given I am on the default search page
    When I search on the phrase "Bartlett, Willard"
    Then the document with title "Bartlett family papers" should appear in the first "5" results

  Scenario: Documents with matching 'unit id' should should be weighted highest
    Given I am on the default search page
    When I search on the phrase "RG 7.2"
    Then the document with title "Records of the Office of the Vice President for University Relations (John J. O'Connor)" should appear as the first result
