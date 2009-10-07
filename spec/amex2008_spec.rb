require "spec"

describe "Amex2008" do

  # Called before each example.
  before(:each) do
    @options = Csv2qif::CLI.load_file "amex2008"
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  [["j", "k", "j\nk"],
   ["#", "k", "#\nk"],
   [nil, "k", "k"],
   ["j", nil, "j"]
  ].each do |j, k, a|
    it "should properly map address" do
      eval(@options[:address]).should == a
    end
  end
end