class MortgageCalc
  include PageObject

  text_field(:home_value, :name => "param[homevalue]")

  def set_random_home_value
    rand = (rand() * 5000000).to_i
    self.home_value = rand

  end
end