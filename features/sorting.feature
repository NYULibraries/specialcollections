  Feature: Sorting options
    In order to sort through my results
    As a researcher
    I want various different sorting options

  Scenario: Default sort option is Relevance
    Given I am on the brief results page
    Then the results should be sorted by "relevance"

  Scenario: Selecting relevance sorts by relevance
    Given I am on the brief results page
    When I select "relevance" from the "Sort by" dropdown 
    Then the results should be sorted by "relevance"
