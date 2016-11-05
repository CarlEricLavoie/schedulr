Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "schedulr"
    Then the exit status should be 0

  Scenario: Add activity and display
    When I run `schedulr add activity_name`
    And I run `schedulr list`
    Then the output should contain "activity_name::0"

  Scenario: Multiple add with same name
    When I run `schedulr add activity_name`
    And I run `schedulr add activity_name`
    And I run `schedulr list`
    Then the output should contain "activity_name::0"
    And the output should contain "activity_name::1"

  Scenario: Set current activity
    Given I have 1 activity defined
    Then I run `schedulr set 0`
    And I run `schedulr current`
    Then the output should contain "activity_name::0"

  Scenario: Remove an activity
    Given I have 1 activity defined
    And I run `schedulr remove 0`
    And I run `schedulr list`
    Then the output should not contain "activity_name::0"

  Scenario: Start timer times
    Given I have 1 activity defined
    When I run `schedulr start`
    Then the exit status should be 0

  Scenario: Start timer multiple times
    Given I have 1 activity defined
    When I run `schedulr start`
    And I run `schedulr start`
    Then the exit status should be 0

  Scenario: Stop timer multiple times
    Given I have 1 activity defined
    When I run `schedulr stop`
    Then the exit status should be 0

  Scenario: Stop timer multiple times
    Given I have 1 activity defined
    When I run `schedulr stop`
    And I run `schedulr stop`
    Then the exit status should be 0

#TODO: Additional tests require a way to mock time in cucumber and will be handled at a later time