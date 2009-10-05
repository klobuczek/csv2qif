require "spec"

describe "Amex2008" do

  # Called before each example.
  before(:each) do
    @options = Csv2qif::CLI.load_symbolized(File.join(File.dirname(__FILE__), "../config/lufthansa.yml"))
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  [["1", "H", "-1"],
   ["1", "S", "1"]
  ].each do |m, n, a|
    it "should properly map amount" do
      eval(@options[:amount]).should == a
    end
  end

  it "should properly map memo" do
    
  end
end