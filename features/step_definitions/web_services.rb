When(/^I build a Save Quote request for Selva$/) do |table|
  service_name = 'Save Quote'
  w = SaveQuote.new(service_name)
  @res = w.post_save_quote_il(service_name, table.rows_hash)
  doc = Nokogiri::XML(@res)
  quoteID = doc.search('quoteID').text
  policyNumber = doc.search('policyNumber').text
  returnMessage = doc.search('returnMessage').text
  p " Result = #{returnMessage}"
  p "Quote ID = #{quoteID}"
  p "Policy Number = #{policyNumber}"
  no_of_submission = policyNumber.split('ACP WC')[1].scan(/[0-9]{2}/)[0]
  p "Number of submission on the account is #{no_of_submission}"
  doc.search('returnMessage').text.should == table.rows_hash["response"]
end

class SaveQuote
  attr_accessor :uri

  def initialize(service_name = self.class.name)
    ;
  end

  def create_extract_table_data(service_name, table)
    @state = table['state'] if service_name.include? 'Save Quote'
  end

  def create_save_quote_payload_il
    "<?xml
<ABC id='N64'>#{$acc_number}</AId>"
  end

  def post_create_save_quote_il(service_name, table)
    create_extract_table_data(service_name, table)
    @uri = ''
    response = RestClient::Request.execute(
        method: 'post',
        url: @uri,
        headers: {'Content-Type' => 'application/xml'},
        payload: create_save_quote_payload_il
    )
    puts(response.body)
    response
  end
end

def post_save_quote_il(service_name, table)
  extract_table_data(service_name, table)
  @uri = 'https://abc'
  response = RestClient::Request.execute(
      method: 'post',
      url: @uri,
      headers: {'Content-Type' => 'application/xml'},
      payload: save_quote_payload_il
  )
  puts(response.body)
  response
end