Feature: Brief result display
  In order to view relevant fields in search results
  As a researcher
  I want to see relevant fields in the brief search display.

  
  Scenario: See brief results display at the collection level 
    Given I am on the brief results page
    And I limit my search to "Archival Collection" under the "Format" category
    Then I should see fields in the following order and value:
    | Format | Archival Collection |
    | Date range | Inclusive, 1978-2012 |
    | Abstract | Mark Bloch is an American fine artist and writer whose work utilizes both visuals and text to explore ideas of long distance communication. This collection contains thousands of examples of original “mail art” sent to and collected by Mark Bloch in New York City from all fifty states and dozens of countries in the form of objects, envelopes, artwork, and enclosures as well as publications, postcards and announcements documenting avant garde cu... |
    | Library | The Fales Library & Special Collections |
    | Call no | MSS 170 |
    And I should see "Abstract" be "450" characters or less
    And I should see "Search all archival materials within this collection" between "Abstract" and "Library"
    When I click on "Search all archival materials within this collection" within css class "dd.blacklight-collection_ssm"
    Then I should see search results


  Scenario: See brief results display at non-collection level
    Given I search on the phrase "Minka"
    Then I should see fields in the following order and value:
    | Format | Archival Object |
    | Contained in | Oral History of the American Left: Radical Histories >> Minka Alesh |
    | Date range | Oct 26, 1982 |
    | Library | The Tamiment Library & Robert F. Wagner Labor Archives |
    | Location | CD: Access OH-02-159, Box: 1, CD: Alesh 1, Cassette: 1, CD: ohaloh020146p1 / /ohaloh020146p2, Box: 1, Cassette: 1 |
    And I should see "To request this item, please note the following information" between "Date range" and "Library"
    When I click on "Oral History of the American Left: Radical Histories" within css class "dd.blacklight-heading_ssm" 
    Then I should see search results

 
 