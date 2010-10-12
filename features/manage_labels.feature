Feature: Manage labels
  In order to find chunks begin and end
  A user
  wants manage labels

  Scenario: Manage chunks from homepage
    Given I am on the homepage
    When I follow "Voir les repères"
    Then I should be on the labels page

  Scenario: Create a chunk from homepage
    Given I am on the homepage
    When I follow "Créer un repère manuel"
    Then I should be on the new label page

  Scenario: List all chunks
    Given the following labels exist
    | name    | timestamp               |
    | Label 1 | January 1, 2010 8:00:15 |
    | Label 2 | January 2, 2010 9:00:30 |
    When I am on the labels page
    Then I should see "1 janvier 2010"
    And I should see "08:00:15"
    And I should see "2 janvier 2010"
    And I should see "09:00:30"

  Scenario: Create a new label
    Given I am on the new label page
    And I fill in "Nom" with "Label 1"
    And I select "1 Janvier 2010 7:00:15" as the "Horaire" date and time
    When I press "Créer"
    Then I should see "Label créé(e) avec succès"
    And I should see "1 janvier 2010 07:00:15"
