require 'rubygems'
require 'watir-webdriver'
require 'selenium-webdriver'

# After do
#   @browser.exit
# end

Before do
  # @browser=Watir::Browser.new :chrome
  @browser=Selenium::WebDriver.for :chrome
end