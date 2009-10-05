require File.dirname(__FILE__) + '/spec_helper.rb'

describe "QIF" do

  # Called before each example.
  before(:each) do
    # Do nothing
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "should properly parse amount" do
    QIF.parse_float("$1,000,000.00").should == Float(1000000)
    QIF.parse_float("$1,00").should == Float(1)
    QIF.parse_float("-$1.00").should == Float(-1)
    QIF.parse_float("$-1.0").should == Float(-1)
    QIF.parse_float("$1,0").should == Float(1)
  end
end