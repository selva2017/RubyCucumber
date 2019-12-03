Feature: Mortgage calculator

  Scenario Outline: Mortgage calculation
    Given I am on mortgage calculator page
    And I enter the home value as "<home_value>"
    And I enter the loan amount as "<loan_amt>"
    And I enter the interest percent as "<interest>"
    Then I click on Calculate button

  Examples:
    | home_value | loan_amt | interest | temp |
    | 1234567    | 543210   | 1.125    | abc     |
    | 999999     | 9999999  | 2.999    | &*(     |

  Scenario: Mortgage calculation
    Given I am on mortgage calculator page
    And I enter the home value as "100"
    And I enter the loan amount as "200"
    And I enter the interest percent as "566"
    Then I click on Calculate button

