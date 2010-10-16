Feature: Manage releases
  In order to update the box
  the administrator
  wants check, download and install new releases

  Background:
    Given the current release is "release-4"
  
  Scenario: Check release without update
    Given the latest release is "release-3"
    When I am on the releases page
    Then I should see "Aucune mise à jour n'est nécessaire"

  Scenario: Check release with update
    Given the latest release is "release-5"
    When I am on the releases page
    Then I should see "Mise à jour disponible"
    And I should see a "Télécharger" link 

  Scenario: Download a release
    Given a new release is available
    And I am on the releases page
    When I follow "Télécharger"
    Then I should see "Téléchargement en cours ..."

  Scenario: Install a downloaded release
    Given a new release is available
    And the new release is downloaded
    When I am on the releases page
    Then I should see "Installer et redémarrer"
