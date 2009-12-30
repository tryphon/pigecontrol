Feature: Manage labels
  In order to find chunks begin and end
  A user
  wants manage labels

  Scenario: Manage chunks from homepage
    Given I am on the homepage
    When I follow "Gérer les repères"
    Then I should be on the labels page

  Scenario: Create a chunk from homepage
    Given I am on the homepage
    When I follow "Ajouter un repère"
    Then I should be on the new label page

  Scenario: List all chunks
    Given the following labels exist
    | name    | timestamp               |
    | Label 1 | January 1, 2010 8:00:15 |
    | Label 2 | January 2, 2010 9:00:30 |
    When I am on the labels page
    Then I should see "January 01, 2010"
    And I should see "08:00:15"
    And I should see "January 02, 2010"
    And I should see "09:00:30"

  Scenario: Create a new label
    Given I am on the new label page
    And I fill in "Name" with "Label 1"
    And I select "January 1, 2010 7:00:15" as the "Timestamp" date and time
    When I press "Créer"
    Then I should see "Label was successfully created"
    And I should see "January 01, 2010 07:00"
