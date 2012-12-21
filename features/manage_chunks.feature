Feature: Manage chunks
  In order to use recorded contents
  A user
  wants manage chunks

  Scenario: Manage chunks from homepage
    Given I am on the homepage
    When I follow "Gérer les extraits"
    Then I should be on the chunks page

  Scenario: Create a chunk from homepage
    Given I am on the homepage
    When I follow "Créer un extrait"
    Then I should be on the new chunk page

  Scenario: List all chunks
    Given the following chunks exist
    | title     | begin                | end                  |
    | Extrait 1 | January 1, 2010 7:00 | January 1, 2010 8:00 |
    | Extrait 2 | January 2, 2010 8:00 | January 2, 2010 9:00 |
    When I am on the chunks page
    Then I should see "Extrait 1"
    And I should see "01 janvier 2010 07:00"
    And I should see "Extrait 2"
    And I should see "02 janvier 2010 08:00"

  Scenario: Create a new chunk
    Given I am on the new chunk page
    And records exist from "1 Janvier 2010 7:00" to "1 Janvier 2010 8:00"
    And I select "1 Janvier 2010 7:00" as the "Horaire de début" date and time
    And I select "1 Janvier 2010 8:00" as the "Horaire de fin" date and time
    When I press "Créer"
    Then I should see "Extrait créé(e) avec succès"
    And I should see "Extrait 01 janvier 2010 07:00"

  Scenario: Destroy a chunk
    Given a chunk exists
    And I am on the chunk's page
    When I follow "Supprimer"
    Then I should be on the chunks page
    And I should see "Extrait supprimé(e) avec succès"
    And the chunk should not exist

  Scenario: Download a wav
    Given a chunk exists 
    And the chunk is completed
    And I am on the chunk's page
    When I follow "Télécharger"
    Then I should download a wav file

  Scenario Outline: Create and download a chunk
    Given I am on the new chunk page
    And I select "1 Janvier 2010 7:00" as the "Horaire de début" date and time
    And I select "1 Janvier 2010 8:00" as the "Horaire de fin" date and time
    And I choose "<format>" 
    And I press "Créer"
    When all chunks are completed
    And I reload the current page
    And I follow "Télécharger"
    Then I should download a <extension> file
    
    Examples:
    | format     | extension |
    | Ogg/Vorbis | ogg       |
    | MP3        | mp3       |
    | Wave       | wav       |

