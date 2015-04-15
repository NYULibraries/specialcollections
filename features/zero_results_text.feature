Feature: Helpful search tips when there are no results
  In order to be able to continue my search when I get no results
  As a researcher
  I want helpful feedback on improving my search.

Scenario: Search doesn't return results
  Given I am on the default search page
  When I search on the phrase "Ekaterina Pechekhonova"
  Then I should see the following text:
    """
    Sorry, no results matched your search.
    Consider searching with different terms - for example, a search for ' "NYU clubs" ' will produce different results than ' "NYU society" ' or ' "New York University clubs" '
    Double check spelling.
    Consider using the facets on the left to browse for related terms.
    """
    
