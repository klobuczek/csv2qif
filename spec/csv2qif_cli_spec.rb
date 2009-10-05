require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require 'csv2qif/cli'

describe Csv2qif::CLI, "execute" do

  it "should print default output" do
    cmd_exec "-h"
    @stdout.should =~ /Usage:/
  end

end

def cmd_exec arguments
  @stdout_io = StringIO.new
  Csv2qif::CLI.execute(@stdout_io, arguments.split(' '))
  @stdout_io.rewind
  @stdout = @stdout_io.read
end
