  Feature: Default sort is relevance
    In order to identify the most relevant results
    As a researcher
    I wan the default sort option to be Relevance

  Scenario: Default sort option is Relevance
    Given I am on the default search page
    When I search on the phrase "bloch"
    Then "Sort by relevance" should be selected for "sort" dropdown