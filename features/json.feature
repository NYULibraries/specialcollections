Feature: JSON rendering
  In order to be able to update special collection data elsewhere
  As a developer
  I want to access a consistent JSON API

  Scenario: Catalog index rendering
    Given I view the catalog index JSON
    Then I should see valid JSON
