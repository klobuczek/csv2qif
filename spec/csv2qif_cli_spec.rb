require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require 'csv2qif/cli'

describe Csv2qif::CLI, "execute" do

  it "should print default output" do
    cmd_exec "-h"
    @stdout.should =~ /Usage:/
  end

  it "load file" do
    Csv2qif::CLI.load_file("amex2008").should_not be_empty
  end


  it "should prepare mappings" do
    options = {:mappings => ["/a/b/c/"]}
    Csv2qif::CLI.prepare_mappings(options)
    options[:mappings].should == [['a', /b/, 'c']]
  end

end

def cmd_exec arguments
  @stdout_io = StringIO.new
  Csv2qif::CLI.execute(@stdout_io, arguments.split(' '))
  @stdout_io.rewind
  @stdout = @stdout_io.read
end
