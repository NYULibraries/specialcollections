Feature:  Enhanced search relevancy
  In order to get most relevant materials
  As a researcher
  I expect different fields and different documents to be weighted on their relevancy

Scenario: Documents with matching unittitles for collection should appear as first results
  Given I am on the default search page
  When I search on the phrase "Ramdasha"
  Then the document with title "Ramdasha Bikceem Riot Grrrl Collection" should appear as first result

Scenario: Documents with matching abstract should appear at the begining of the search results
  Given I am on the default search page
  When I search on the phrase "How Should a person be ?"
  Then the document with title "Sheila Heti Riot Grrrl Collection" should appear in the "5" first results

Scenario: Documents with matching creator should appear at the begining of the search results
  Given I am on the default search page
  When I search on the phrase "Bartlett, Willard"
  Then the document with title "Bartlett family papers" should appear in the "10" first results

Scenario: Documents with matching unitid should appear at the begining of the search results
  Given I am on the default search page
  When I search on the phrase "RG 7.2"
  Then the document with title "Records of the Office of the Vice President for University Relations (John J. O'Connor)" should appear in the "3" first results


