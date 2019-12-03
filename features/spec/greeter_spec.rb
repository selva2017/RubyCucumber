require 'rspec'
# require 'greeter_rspec_api'

class RSpecGreeter
  def greet
    "Hello RSpec!"
  end
end

describe "RSpec Greeter" do
  it "should say 'Hello RSpec!' when it receives the greet() message" do
    greeter = RSpecGreeter.new
    greeting = greeter.greet
    greeting.should == "Hello RSpec!"
  end

  it "should check the greet() message 'Hello RSpec!'" do
    greeter = RSpecGreeter.new
    puts greeting = greeter.greet
    greeting.should == "Hello RSpec!"
  end
end