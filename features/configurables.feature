Feature: Configurables
  In order to change configurable options on the site
  As an admin
  I want to be able to change them
  
  Scenario: Editing Config
    When I am on the config page
      And I fill in "Notify Email" with "paul@rslw.com"
      And I press "Save"
    Then the "Notify Email" field should contain "paul@rslw.com"
