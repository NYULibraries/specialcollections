Feature: Brief result display
  In order to view relevant fields in search results
  As a researcher
  I want to see relevant fields in the brief search display.

  
  Scenario: Pre limit search by collection
    Given I am on the default search page
    When I search on the phrase "bloch"
    And I limit my search to "Archival Collection" under the "Format" category
    Then I should see fields in the following order and value:
    | Format | Archival Collection |
    | Date range | Inclusive, 1978-2012 |
    | Abstract | Mark Bloch is an American fine artist and writer whose work utilizes both visuals and text to explore ideas of long distance communication. This collection contains thousands of examples of original “mail art” sent to and collected by Mark Bloch in New York City from all fifty states and dozens of countries in the form of objects, envelopes, artwork, and enclosures as well as publications, postcards and announcements documenting avant garde cu... |
    | Library | The Fales Library & Special Collections |
    | Call no | MSS 170 |


 