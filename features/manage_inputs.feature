Feature: Manage inputs
  In order to integrate the box in its working environment
  the administrator
  wants to change sound input settings
  
  Scenario: Modify the alsa input gain
    Given I am on the edit input page
    And I fill in "Gain" with "-6"
    When I press "Modifier"
    Then the puppet configuration should contain "alsa_input_gain" with "-6"
