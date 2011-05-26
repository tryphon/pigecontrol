Feature: Create chunk from labels
  In order to create quickly correct chunks
  An user
  wants create use labels to create chunks
  
  Scenario: Select a first label
    Given a label exists with timestamp: "17:00:00"
    When I am on the labels page
    And I follow "Sélectionner ce repère"
    Then I should see "17:00:00" within "div.label_selection"

  Scenario: Select a second label
    Given a label exists with timestamp: "17:00:00"
    And that label is selected
    And another label exists with timestamp: "18:00:00"
    When I select the 2nd label
    Then I should be on the new chunk page
    And I should see "Extrait défini à partir des deux repères sélectionnés"
    And the "Horaire de début" datetime should contain "17:00:00"    
    And the "Horaire de fin" datetime should contain "18:00:00"    

  Scenario: Clear the label selection
    Given a label exists with timestamp: "17:00:00"
    And that label is selected
    When I follow "Vider la sélection de repère"
    Then I should not see "Vider"

  Scenario: Create a chunk with a single label
    Given a label exists with timestamp: "17:00:00"
    And that label is selected
    When I follow "Nouvel extrait à partir de ce(s) repère(s)"
    Then I should be on the new chunk page
    And the "Horaire de début" datetime should contain "17:00:00"    
    And the "Horaire de fin" datetime should contain "17:00:00"    
