require 'spec_helper'

describe "Amex" do

  # Called before each example.
  before(:each) do
    @options = Csv2qif::CLI.load_file "amex"
  end

  # Called after each example.
  after(:each) do
    # Do nothing
  end

  [["j", "k", nil, "j\nk"],
   ["#", "k", nil, "#\nk"],
   [nil, "k", nil, "k"],
   ["j", nil, nil, "j"]
  ].each do |j, k, l, a|
    it "should properly map address" do
      eval(@options[:address]).should == a
    end
  end
end