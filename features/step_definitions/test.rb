Given(/^I am on Google home$/) do
  require "selenium-webdriver"

# start an instance of firefox with selenium-webdriver
  driver = Selenium::WebDriver.for :firefox # generate browser object

  driver.get "http://www.google.com"

# wait for a specific element to show up
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { /Sample Title/.match(browser.page_source) }

  driver.find_element(:id, 'hoge').send_keys('fuga')
  driver.find_element(:id, 'goto_next').click

  puts "Test Passed: Page 1 Validated"

# Drop browser object
  driver.quit
end