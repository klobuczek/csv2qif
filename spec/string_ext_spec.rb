require File.dirname(__FILE__) + '/spec_helper.rb'

describe "String extenssion" do

  # Called before each example.
  before(:each) do
    # Do nothing
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  it "should properly parse amount" do
    "$1,000,000.00".to_f.should == Float(1000000)
    "$1,00".to_f.should == Float(1)
    "-$1.00".to_f.should == Float(-1)
    "$-1.0".to_f.should == Float(-1)
    "$1,0".to_f.should == Float(1)
  end
end