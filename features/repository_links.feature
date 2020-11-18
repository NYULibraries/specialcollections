Feature: Stable Repository Links
  In order to find primary sources in the holdings of a particular library
  As a user
  I want a stable link to search the holdings of a specific library.

  Scenario: Fales homepage
    Given I am on the "fales" search page
    Then the limit "The Fales Library & Special Collections" should be selected under the "Library" category
    And I should see the following informational text "The Fales Library & Special Collections, comprising 350,000 volumes of book and print items, over 11,000 linear feet of archive and manuscript materials, and about 90,000 audiovisual elements, houses the Fales Collection of rare books and manuscripts in English and American literature, the Downtown Collection, the Food and Cookery Collection, the Riot Grrrl Collection, and the general Special Collections of the NYU Libraries."
    And I should see the following link "http://www.nyu.edu/library/bobst/research/fales/"
    And I should see search results

  Scenario: Tamiment homepage
    Given I am on the "tamiment" search page
    Then the limit "Tamiment Library & Wagner Labor Archives" should be selected under the "Library" category
    And I should see the following informational text "The Tamiment Library and Robert F. Wagner Labor Archives collects material in all formats documenting the history of labor, the Left, political radicalism, and social movements in the United States, with particular strengths in communism, anarchism, and socialism.  It is also the repository for the Archives of Irish America and the Abraham Lincoln Brigade Archives."
    And I should see the following link "http://www.nyu.edu/library/bobst/research/tam/"
    And I should see search results

  Scenario: University Archives homepage
    Given I am on the "universityarchives" search page
    Then I should see the following informational text "The New York University Archives serves as the final repository for the historical records of NYU. Its primary purpose is to document the history of the University and to provide source material for administrators, faculty, students, alumni, and other members of the University community, as well as scholars, authors, and other interested persons who seek to evaluate the impact of the University's activities on the history of American social, cultural, and intellectual development."
    And I should see the following link "http://www.nyu.edu/library/bobst/research/arch/"

  Scenario: New-York Historical Society homepage
    Given I am on the "nyhistory" search page
    Then I should see the following link "http://www.nyhistory.org/library/"

  Scenario: Center for Brooklyn History homepage
    Given I am on the "brooklynhistory" search page
    Then I should see the following informational text "The Center for Brooklyn History collects, preserves, and provides access to the most expansive collection of Brooklyn history and life in the world. The combined collections that comprise the new Center for Brooklyn History's holdings include over 250,000 photographs, 37,000 books, 1,800 archival collections, 2,500 maps and atlases, 5,700 artifacts, 300 paintings, 1,400 oral history interviews, and more. The collections foster new and cutting-edge scholarship, support public learning and research, and enrich CBH's exhibitions, educational activities, and public programming."
    Then I should see the following link "http://www.brooklynhistory.org/library/search.html"

  Scenario: Poly Archives homepage
    Given I am on the "poly" search page
    Then I should see the following link "http://library.poly.edu/archives"

  Scenario: Research Institute for the Study of Man homepage
    Given I am on the "rism" search page
    Then I should see the following informational text "The RISM Research Collections and Archives have been transferred to the New York University Archives."
    And I should see the following link "http://www.nyu.edu/library/bobst/research/arch/"
