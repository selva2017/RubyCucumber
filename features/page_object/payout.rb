# class PayoutPage
#   include PageObject
#
#   text_field(:interest_rate, :id => "i")
#
#   text_field(:date_of_birth, :id => "dob")
#   text_field(:today_date, :id => "today")
#   label(:Total_accbal, :id => "")
#   label(:payment_year, :id => "")
#   label(:payment_calculation, :id => "")
#   label(:no_years, :id => "")
#   label(:hypothetical_returns, :id => "")
#   label(:Dateof_birth, :id => "")
#   text_field(:dob_month, :id => "")
#   text_field(:dob_date, :id => "")
#   text_field(:dob_year, :id => "")
#   text_field(:account_balance, :id => "")
#   select_list(:payments_peryear, :id => "")
#   radio(:payment_calculation, :id => "")
#   button(:clear_all, :id => "clear_all_fields")
#   button(:continue, :id => "")
#   select_list(:no_years, :id => "")
#   select_list(:hypothetical_returns, :id => "")
#   button(:clear_all, :id => "")
#   button(:modify_input, :id => "")
#   button(:continue, :id => "")
#   button(:illustrate_new_client, :id => "")
#   button(:print_report, :id => "")
#   select_list(:monthly_gross, :id => "")
#   select_list(:annual_gross, :id => "")
#
#   def todays_date_method
#
#     today = Date.now("%dd%mm%yyyy")
#
#     self.today_date = today
#
#   end
# end
