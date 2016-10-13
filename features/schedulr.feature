Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "schedulr"
    Then the exit status should be 0

  Scenario: Add one activity and list it
    When I run `schedulr add test`
    And I run `schedulr list`
    Then the output should contain exactly:
    """

    test::0
    """

  Scenario: Multiple add with same name
    When I run `schedulr add test`
    And I run `schedulr add test`
    And I run `schedulr list`
    Then the output should contain exactly:
    """


    test::0
    test::1
    """

  Scenario: Create an activity, define it as current and display it
    When I run `schedulr add test`
    And I run `schedulr set 0`
    And I run `schedulr current`
    Then the output should contain exactly:
    """


    test::0
    """