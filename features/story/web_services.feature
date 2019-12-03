Feature: Test

  Scenario: Automate Booksmart application Selenium
    Given I am on booksmart page Selenium
    When I create a new book of business Selenium
    And I upload a book of business Selenium
    Then I should generate report Selenium

  Scenario Outline: Validate the Save Quote service with POST request for Selva
    When I build a Save Quote request for Selva
      | state    | <state>    |
      | response | <response> |
    Examples:
      | state | response |
      | IL    | Success  |
