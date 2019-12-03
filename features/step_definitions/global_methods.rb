# -*- encoding : utf-8 -*-
require 'date'
require File.dirname(__FILE__) + '/global_objects'
def time_out(object)
  puts "#{object}: Content not on page. Time out."
end

def replace_regex_special_chars(string)
  temp_string = string.gsub("(", '\(')
  temp_string = temp_string.gsub("$", '\$')
  temp_string = temp_string.gsub("^", '\^')
  temp_string.gsub!('[','\[')
  temp_string.gsub!(']','\]')
  temp_string.gsub!(")", '\)')
  temp_string.gsub(".", '\.')
end

def verify_money_sources_irs_order(money_sources)
  irs_money_sources_index = ['Employer Match','Salary Reduction','Rollover (Pre-Tax)','Rollover 457','Roth Contribution','Roth Rollover',
                             'Roth Rollover 457', 'Employer Mandatory (Pre-Tax)','Employer Money Purchase','Drop/Accumulated Benefits','Employer Discretionary Account',
                             'Mandatory Employee Pre-Tax','Qualifying Medical Care Expense','Health Care Insurance Premium','IRA Traditional','IRA Traditional Rollover','IRA Roth','IRA Roth Rollover','IRA Conversion',
                             'After-Tax Contribution', 'After-Tax Rollover']
  money_sources_sorted = sort_with_index(money_sources,irs_money_sources_index)
  money_sources_sorted.to_s.strip.should  == money_sources.to_s.strip
end

def sort_with_index(array,index_array)
  return array.sort do |a, b|
    index_array.index(a).to_i <=> index_array.index(b).to_i
  end
end

def get_age dob

  if dob.class == String
    dob = dob.split("/")
    dob = {:month => dob[0], :day => dob[1], :year => dob[2]}
  end

  dob_month = dob[:month].to_i
  dob_day = dob[:day].to_i
  dob_year = dob[:year].to_i

  time = Time.new
  current_year = time.year.to_i
  current_month = time.month.to_i
  current_day = time.day.to_i

  age = current_year - dob_year
  if current_month < dob_month
    age = age - 1
  elsif current_month == dob_month
    if current_day < dob_day
      age = age - 1
    end
  end

  age
end

def to_snake_case(text)
  text.strip!
  text.downcase!
  text.gsub(" ", "_")
end

def convert_to_currency(value)
  if value != ""
    value=value.to_s

    if value.include? "-"
      value.gsub!("-", "")
      negative = true
    end

    if value.include? ","
      value.gsub!(",", "")
    end

    value.strip!
    value=value.to_f
    value = ("%.2f" % value)
    #value=value.to_s
    if(value.scan(/.*\.[0-9]$/).join==value)
      value=value+"0"
    elsif(value.include?(".")==false)
      value=value+".00"
    end

    index_array=Array.new

    value.reverse!
    for index in(4..value.length-1)
      if(index%3==0)
        index_array.push(index)
      end
    end
    index_array.reverse!
    for index in(0..index_array.size-1)
      value.insert(index_array[index],',')
    end
    value.reverse!

    if negative
      return "-$"+value
    else
      return "$"+value
    end
  else
    return value
  end
end

def get_valid_password
  char_type_1 = (0...3).map { ('a'..'z').to_a[rand(26)] }.join
  char_type_2 = (0...3).map { ('A'..'Z').to_a[rand(26)] }.join
  char_type_3 = (0...3).map { (0..9).to_a[rand(10)] }.join
  @password = char_type_1 + char_type_2 + char_type_3
end

def get_non_compliant_password
  (0...9).map { ('a'..'z').to_a[rand(26)] }.join + '1'
end

def get_valid_username(ssn = "")
  ssn = (0...9).map { (0..9).to_a[rand(10)] }.join if ssn == ""
  %Q{#{$environment.upcase + 'RSCTest' + scramble_number_string(ssn)}}
end

def get_invalid_password
  char_type_1 = (0...7).map { ('a'..'z').to_a[rand(26)] }.join
  char_type_2 = (0...1).map { (0..9).to_a[rand(10)] }.join
  char_type_3 = (0...15).map { (0..9).to_a[rand(10)] }.join
  char_type_4 = ['>', '"', "'", '%', ')']
  password1   = char_type_1 + char_type_2 + char_type_4[rand(char_type_4.size)]
  passwords   = [password1, char_type_3]
  @password   = passwords[rand(passwords.size)]
end

def get_external_plan_sponsor
  username = inline_puts(get_validated_external_plan_sponsor_username, "username")
  password = get_valid_password
  reset_seuss_password(username, password, "RESET_PASSWORD")
  modify_user_account_status(username, "ENABLED")
  {:username => username, :password => password}
end
#TOL
class String

  def strip_currency
    self.gsub(",","").gsub("$","").to_f
  end

  def escape_regex_characters
    self.gsub("$", "\\$").gsub(".", "\\.").gsub("(","\\(").gsub(")","\\)")
  end

end

#pass of variable & if condition for environment can be removed once June 2015 rlse moves to STG
def checkfor_foresee_prompt(environment = 'stg')
  if $environment == 'stg' && environment == 'stg'
    end_time = Time.now + CHECK_TIMEOUT
    until Time.now > end_time || foresee_decline?
      @browser.button(:id => "decline").click if foresee_decline?
      sleep 0.25
    end
    @browser.link(:text => "decline").click if foresee_decline?
  end
  if $environment == 'st' && environment == 'st'
    end_time = Time.now + CHECK_TIMEOUT
    until Time.now > end_time || foresee_decline_for_st?
      @browser.link(:text => "No, thanks").click if foresee_decline_for_st?
      sleep 0.25
    end
    @browser.link(:text => "No, thanks").click if foresee_decline_for_st?
  end
end

#foresee_decline? method can be replaced with foresee_decline_for_st? once June 2015 rlse moves to STG
#after verifying that checkfor see prompt is no more a buttong with id as 'decline'
def foresee_decline?
  @browser.button(:id => "decline").exists? && @browser.button(:id => "decline").visible?
end

def foresee_decline_for_st?
  @browser.div(:class => "fsrDialog").exists? && @browser.link(:text => "No, thanks").visible?
end

#TOL 7.10.2013
def inline_puts(txt, label = "")
  puts "#{label}: #{txt}"
  txt
end

def to_abbr_state state
  sql_statement = "select abbreviation from province where name = '#{state}'"
  $dc.execute_sql(sql_statement)[0]["abbreviation"]
end

#TOL 8.13.2013 - takes a tag or key and returns the corresponding content from the content_matrix.yml file
def get_content_by_tag(tag)
  @content_matrix ||= YAML::load(File.open("features/config/content_matrix.yml")) #only loads the matrix if it has not been loaded this session data cleanup is done in the at_exit hook
  fail "tag #{tag} was not found in The Content Matrix YAML file: features/config/content_matrix.yml" if @content_matrix[tag] == nil
  @content_matrix[tag]
end

def get_seuss_environment
  # navigate_to_uri build_url_for(:prop_list)
  # "https://#{@browser.td(:xpath => "//td[contains(.,'seuss.server')]/../td[2]").text}"

  siteResponse = RestClient.get get_dbList_url_for

  siteResponse.upcase!

  breakTd = siteResponse.split("<TD>SEUSS</TD>")[1]
  descriptionTd = breakTd.split("<TD>IMEDIA.UTILS.SEUSS</TD>")[0]
  seussEndpoint = descriptionTd.gsub("</TD>","").gsub("<TD>","")

  seussUrl=(seussEndpoint.include? "NWIE.NET")? "https://" : "http://"
  seussUrl+=seussEndpoint

  seussUrl
end
def get_dbList_url_for(_env = $environment)
  _url=($environment.include? ":")? "http://" : "https://"
  _url+= $environment
  _url+=($environment.include? ":")? "/" : "." if $environment != "st" and $environment != "it"
  _url+=($environment.include? ":")? "/" : "-" if $environment == "st" or $environment == "it"
  _url+= $db_list[($db_list[_env] == nil)? :default : _env]

  inline_puts _url,"dbList"
end
def get_dbList_json_url_for(_env = $environment)
  _url=($environment.include? ":")? "http://" : "https://"
  _url+= $environment
  _url+=($environment.include? ":")? "/" : "." if $environment != "st" and $environment != "it"
  _url+=($environment.include? ":")? "/" : "-" if $environment == "st" or $environment == "it"
  _url+= $db_json[($db_json[_env] == nil)? :default : _env]

  inline_puts _url,"dbList json"
end

def progress_bar_description
  on_page(ParticipantPage).progress_bar_element.text.gsub(/STEP (\d) OF (\d): /,"")
end

def progress_bar_total
  on_page(ParticipantPage).progress_bar_element.text.gsub(/STEP (\d) OF /,"").gsub(/: .*/,"")
end

def progress_bar_current
  on_page(ParticipantPage).progress_bar_element.text.gsub(/STEP /,"").gsub(/ OF .*/,"")
end

def progress_bar_percentage
  @browser.dd(:class => "complete").style.gsub("width: ","").gsub(";","")
end

def progress_bar_remaining
  @browser.dd(:class => "toDo").style.gsub("width: ","").gsub(";","")
end

def get_random_ssn
  9.times.map{rand(10)}.join
end

def get_random_number_string length
  length.times.map{rand(10)}.join
end

def get_random_email
  4.times.map{('a'..'z').to_a[rand(26)]}.join + '@' + 4.times.map{('a'..'z').to_a[rand(26)]}.join + '.' + 'com'
end

def get_random_number_with_two_decimal_values_string length
  length.times.map{rand(10)}.join + "." + 2.times.map{rand(10)}.join
end

def log_out_if_not_logged_out
  current_url =  @browser.url
  parsed_host =  URI.parse(current_url).host
  logout_url =''
  if current_url.include? '/iApp/rsc'
    logout_url ='https://' + parsed_host + '/iApp/rsc/logoutSubmit.x'
  elsif current_url.include? '/iApp/rsc/plansponsor'
    logout_url ='https://' + parsed_host + '/iApp/rsc/plansponsor/logoutSubmit.x'
  end
  puts "logout Url:  #{logout_url}"

  if logout_url.include? '/iApp/rsc'
    @browser.goto logout_url
  end
end

def titleize str
  str.split.map(&:capitalize).join(' ')
end

#TOL 8.31.2013 - patch for running test against Developers� local builds
def build_url_for(site)
  fail "$environment needs to be set before calling build_url_for" unless $environment
  url =($environment.include? ':')? 'http://' : 'https://'
  url+= $environment
  url+=($environment.include? ":")? "/" : "." if $environment != "st" and $environment != "it"
  url+=($environment.include? ":")? "/" : "-" if $environment == "st" or $environment == "it"
  url+=($environment.include? 'nwservicecenter')? $site_url[:YSC] : $site_url[site]
  inline_puts url,'url'
end

def convert_redacted_value_from_bullets_to_x(value)
  redacted_character = "\342\200\242"
  if value.include? "#{redacted_character} "
    redacted_character +=  " "
  end

  value_after_redaction = value.gsub("#{redacted_character}", "X")

  inline_puts(value_after_redaction, "value_after_redaction")
end

def redact_dob_with_x(dob)
  redacted_value = dob.split("/")
  (redacted_value.size-1).times.each do |index|
    redacted_value[index].gsub!(/\d{1,}/, "XX/")
  end
  redacted_value.join
end

def dob_day_month_format
  ["5/5","05/5","5/05","05/05"]
end

def setup_online_access_session_clear
  if @browser.h1(:id => "page-title").exists? and @browser.h1(:id => "page-title").text == "Set Up Online Access"
    navigate_to_uri(build_url_for("Forgot Your Username"))
    on_page(ForgotUsernamePage).cancel
    on_page(ModalPopUp).yes_element.fire_event("onClick") if on_page(ModalPopUp).yes?
  end
end

def get_pdf_content_by_pages(urbo_number, page, reader)
  start_page, start_page_num = get_pdf_content_page(reader, get_content_by_tag("#{urbo_number}-#{page}-START"))
  end_page, end_page_num = get_pdf_content_page(reader, get_content_by_tag("#{urbo_number}-#{page}-END"), start_page_num)
  pdf_content = start_page.text
  while start_page_num != end_page_num
    start_page_num += 1
    pdf_content += reader.pages[start_page_num].text
  end
  pdf_content
end

def get_pdf_content_page(reader, content, offset = 0)
  page_num = offset
  reader.pages[offset..-1].each do |page|
    return page, page_num if page.text.gsub(/\s+/, "").include?(content.gsub(/\s+/, ""))
    page_num += 1
  end
  fail "'#{content}' was not found in the pdf"
end

# Generates a random string from a set of easily readable characters based on the size defined
def generate_random_code(size = 6)
  charset = %w{ % $ ^ & * ( ) @ { } | ~ < > / ? " A C D E F G H J K M N P Q R T V W X Y Z a c d e f g h j k m n p q r t v w x y z 0 1 2 3 4 5 6 7 8 9}
  (0...size).map{ charset.to_a[rand(charset.size)] }.join
end

def login_for_session_change
  navigate_to_uri(build_url_for("Internal-Participant"))
  internal_participant_info = get_internal_participant_user
  on_page(LoginPage).login_as(internal_participant_info[:username], internal_participant_info[:password])
end

def convert_irs_code code
  IRS_MAP.has_key?(code) ? IRS_MAP[code] : code
end

def convert_mri_account_code code
  MRP_ACCOUNT_MAP.has_key?(code) ? MRP_ACCOUNT_MAP[code] : code
end

def convert_state_abbreviation code
  STATE_ABBREVIATIONS.has_key?(code) ? STATE_ABBREVIATIONS[code] : code
end

def convert_loan_code(loan_type)
  LOAN_TYPE_MAP.has_key?(loan_type) ? LOAN_TYPE_MAP[loan_type] : loan_type
end

def get_all_links_by_text(text)
  @browser.links(:text => text)
end

def conversion_number_of_accounts_to_symbol(number_of_accounts)
  NUMBER_OF_ACCOUNTS_TO_SYMBOL[number_of_accounts]
end

def convert_decimal_to_percent_string decimal
  '%.2f' % (decimal * 100)
end

def convert_frequency frequency
  if FREQUENCY_MAP.has_key? frequency.downcase.to_sym
    FREQUENCY_MAP[frequency.downcase.to_sym]
  else
    frequency
  end
end

def convert_pay_frequency_name(pay_code_frequency_type_code)
  PAY_FREQUENCY_NAME[pay_code_frequency_type_code]
end

def convert_pay_frequency_code_to_number(pay_code_frequency_type_code)
  PAY_FREQUENCY_NUMBER[pay_code_frequency_type_code]
end

def get_employer_address employer
  sql_statement =
      "select
          address1,
          address2,
          city,
          province_abbreviation,
          postal_code
      from
          organization o,
          address a
      where
          o.organization_seq_id = a.organization_seq_id
          and name = '#{employer}'"

  $dc.execute_sql(sql_statement)[0]
end

def get_employer_oid employer
  sql_statement =
      "select
          org_role_seq_id
      from
          organization o,
          organization_role org
      where
          o.organization_seq_id = org.organization_seq_id
          and ORGANIZATION_ROLE_TYPE_CODE = 'PLSPON'
          and name = '#{employer}'"

  $dc.execute_sql(sql_statement)[0]["org_role_seq_id"]
end

def scrub string
  string.gsub(/\d{5}/,'*****')
end

def scramble_digit digit
  scrambled_digit = digit + 6
  scrambled_digit -= 10 if scrambled_digit > 9
  scrambled_digit
end

def de_scramble_digit scrambled_digit
  digit = scrambled_digit - 6
  digit += 10 if digit < 0
  digit
end

def scramble_number_string number_string
  new_number = ''
  number_string.each_char{|character| new_number += scramble_digit(character.to_i).to_s}
  new_number
end

def de_scramble_number_string number_string
  new_number = ''
  number_string.each_char{|character| new_number += de_scramble_digit(character.to_i).to_s}
  new_number
end

def convert_role_to_role_num(role)
  role_id = {"ESA" => "48", "ESA Level I" => "48", "Employer Roll Up"  => "92", "RIA" => "93", "Employer Reporting" => "91", "Employer Access" => "47"}
  role_id[role]
end

# @param [String] xls_path
# @param [String] workbook_name
# @return [Workbook]
def load_excel_file(xls_path, workbook_name)
  if @excel == nil
    require 'jruby-win32ole'
    @excel ||= WIN32OLE.new("Excel.Application")
    @excel.visible = true
  end

  @workbooks ||= {}
  workbook = @excel.Workbooks.open(xls_path)
  @workbooks[workbook_name] = workbook
end

# @param [String] workbook_name
# @param [String] worksheet
def excel_open_worksheet(workbook_name, worksheet)
  if @workbooks != nil
    workbook = @workbooks[workbook_name]
    if workbook != nil
      workbook.Worksheets(worksheet)
    else
      puts "Error, no workbook with name #{workbook_name} found"
    end
  end
end

def excel_destroy
  begin
    @workbooks.each { |name, workbook|
      puts 'Saving workbook: ' + name + ' saved: ' + ((workbook.saved) ? 'true' : 'false')
      workbook.saved = true
      workbook.Save
      workbook.Close(0)
    }
    #@excel.ActiveWorkbook.Close(0)
    @excel.Quit()

    Java::OrgRacobCom::ComThread.Release
  rescue
    #puts exception
  end
end

# Needs modification to accommodate if current date is example 1/1/2001
def generate_random_date_of_birth(age = 27)
  current_year = Time.now.to_date
  year_born    = (current_year.strftime('%Y').to_i - age.to_i).to_s
  random_day   = "%.2d" % rand(1..current_year.strftime('%d').to_i)
  month        = current_year.strftime('%m').to_i
  random_month = "%.2d" % rand(1..month)
  random_month + '/' + random_day.to_s + '/' + year_born
end

def create_needed_dirs(dirname)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end
end

def get_current_date
  DateTime.now.strftime("%m/%d/%Y")
end

def visible_text element, identifier={:class => 'semantic'}
  element.text.gsub(element.span(identifier).text, '').strip
end

def convert_role_user user_type
  ROLE_MAP.has_key?(user_type) ? ROLE_MAP[user_type]: (fail "The user given does not correspond to a specific role")
end

def get_current_quarter_dates
  date  = Date.today.strftime("%m/%Y")
  month = date.split("/")[0].to_i
  year  = date.split("/")[1].to_i
  if month <= 3
    begin_date_string = "01/01/#{year}"
    end_date_string   = "03/31/#{year}"
  elsif month <= 6
    begin_date_string = "04/01/#{year}"
    end_date_string   = "06/30/#{year}"
  elsif month <= 9
    begin_date_string = "07/01/#{year}"
    end_date_string   = "09/30/#{year}"
  else
    begin_date_string = "10/01/#{year}"
    end_date_string   = "12/31/#{year}"
  end
  return begin_date_string, end_date_string
end

#TOL 10.30.2013 - passwords to use when bypassing the suess service
def external_mocked_seuss_password; "secret1" end
def internal_mocked_seuss_password; "secret2" end

def get_internal_participant_user_password
  ($environment == "st" || $environment == "it") ? internal_mocked_seuss_password : "Password1"
end

def get_valid_password_to_reset_on_iam_server
  'Password1'
end

def get_invalid_new_password_values
  passwords   = []
  char_type_1 = (0...7).map { ('a'..'z').to_a[rand(26)] }.join
  char_type_2 = (0...1).map { (0..9).to_a[rand(10)] }.join
  char_type_3 = (0...15).map { (0..9).to_a[rand(10)] }.join
  char_type_4 = ['^', '&', '*', '(', '<', '>', '"', "'", '%', ')']
  passwords << char_type_1
  passwords << char_type_1 + char_type_1
  passwords << char_type_1.upcase + char_type_1 + "@"
  passwords << char_type_1.upcase + "@"
  passwords << char_type_1.upcase + char_type_1
  passwords << char_type_1 + "#"
  char_type_4.each do |value|
    passwords << char_type_1.upcase + value + char_type_2 + char_type_1
  end
  passwords << char_type_3
end

#must use .focus on element first
def move_slider_element direction
  if direction == "right"
    @browser.send_keys(:page_up)
  else
    @browser.send_keys(:page_down)
  end
end

#must use .focus on element first
def move_slider_element_by_one direction
  if direction == "right"
    @browser.send_keys(:arrow_right)
  else
    @browser.send_keys(:arrow_left)
  end
end