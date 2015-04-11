Feature: No Results Text
  As a researcher,
  I want helpful feedback on improving my search when I get no results.

Scenario: When search doesn't return results search tips are displayed on the page
  Given I am on the default search page
  When I search on the phrase "Ekaterina Pechekhonova"
  Then I should see the following text
  """
  Sorry, no results matched your search.
  Consider searching with different terms - for example, a search for ‘ “NYU clubs”’ will produce different results than ‘ “NYU society” ‘ or ‘ “New York University clubs” ‘
  Double check spelling.
  Consider using the facets on the left to browse for related terms.
  """
