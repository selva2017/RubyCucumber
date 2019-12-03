Given(/^I am on mortgage calculator page$/) do
  @browser.goto "http://www.mortgagecalculator.org/"
  # my_methods
end

And(/^I enter the home value as "([^"]*)"$/) do |home_value|
  @browser.text_field(:name => "param[homevalue]").set home_value
end

And(/^I enter the loan amount as "([^"]*)"$/) do |loan|
  @browser.text_field(:name => "param[principal]").set loan
  end

And(/^I enter the interest percent as "([^"]*)"$/) do |int|
  @browser.text_field(:name => "param[interest_rate]").set int
end

Then(/^I click on Calculate button$/) do
  @browser.button(:value => "Calculate").click
end