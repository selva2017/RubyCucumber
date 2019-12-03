Given(/^I am on booksmart page Selenium$/) do
  # Working code starts for Selenium ####
  @browser.get("http:")
  @browser.find_element(:id => "USERID").send_keys "agent"
  @browser.find_element(:id => "PASSWORD").send_keys "password"
  sleep 2
  @browser.find_element(:xpath => "//form[@id='logon']//input[@id='NEXT']").click
  sleep 2
  # Working code ends for Selenium ####
end

When(/^I create a new book of business Selenium$/) do
  @browser.find_element(:class => "new_book").click
  # @browser.text_field(:id => "book_name").set "Test Selva"
  @browser.find_element(:id => "book_name").send_keys "Test Selva"
  # @browser.text_field(:id => "book_description").set "Test Description"
  @browser.find_element(:id => "book_description").send_keys "Test Description"
  # @browser.text_field(:id => "book_source").set "Test Source"
  @browser.find_element(:id => "book_source").send_keys "Test Source"
  # @browser.text_field(:id => "prior_carrier").set "Test Carrier"
  @browser.find_element(:id => "prior_carrier").send_keys "Test Carrier"
  # @browser.button(:value => "Continue").click
  @browser.find_element(:name => "create").click
  sleep 5
end

And(/^I upload a book of business Selenium$/) do
  # @browser.link(:title => "import more policies").click
  @browser.find_element(:link_text => "import more policies").click
  # @browser.select_list(:id => "import_modules_selector").option(:value => "XML_BULK_ZIP").click
  dropdown = @browser.find_element(:id => 'import_modules_selector')
  select_list = Selenium::WebDriver::Support::Select.new(dropdown)
  select_list.select_by(:text, 'Upload Zip File containing Bulk ACORD XMLs')
  # @browser.button(:id => "import_button").click
  @browser.find_element(:id => "import_button").click
  # @browser.file_field(:id => "fileName").set("C:/Users/arumus2/Documents/BookSmart/AUTO-15.zip")
  element = @browser.find_element(:id => "fileName")
  element.send_keys("C:/Users/arumus2/Documents/BookSmart/AUTO-15.zip")
  # @browser.button(:value => "Continue").click
  @browser.find_element(:name => "upload").click
end

Then(/^I should generate report Selenium$/) do
  sleep 60
  @browser.find_element(:class => "first_item").click
  test_book = "Test Selva"
  @browser.find_element(:xpath => "//table[@id='library_table']/tbody/tr/td[contains(.,'#{test_book}')]").click
  sleep 10
end