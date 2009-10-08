require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require 'csv2qif/cli'

describe Csv2qif::CLI, "execute" do

  it "should print default output" do
    cmd_exec(%w{-h}).should =~ /Usage:/
  end

  {:s1 => %w{-b schwabone spec/data/s1.csv}
  }.each do |name, arguments|
    it "should covert #{name}" do
      cmd_exec(arguments).should be_empty
      File.read(file name, :qif).should == File.read(file name, :qif, :target)
    end
  end

  {:c1 => %w{-d 0 -t Cash -D c -P b -L a -T -d.to_f -m /^/Expenses:/},
   :ag7 => %w{-w e -D e -P g -L "#{a}:#{d}" -m /^/Expenses:/ -T} << "h ? -h.to_f : i",
   :ab7 => %w{-w e -D e -P g -L "#{a}:#{d}" -m /^/Expenses:Private:/ -T} << "h ? -h.to_f : i"
  }.each do |name, arguments|
    it "should covert #{name} reading from standard input" do
      cmd_exec_file(arguments, file(name, :csv), file( name, :qif)).
              should == File.read(file name, :qif, :target)
    end
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

def file *file
  File.join(File.dirname(__FILE__), "data", file.join('.'))
end

def cmd_exec_file arguments, stdin_file, stdout_file
  stdin = File.open(stdin_file, "r")
  stdout = File.open(stdout_file, "w")
  Csv2qif::CLI.execute(stdin, stdout, arguments)
  stdin.close
  stdout.close
  File.read(stdout_file)
end

def cmd_exec arguments
  stdout =  StringIO.new
  Csv2qif::CLI.execute(STDIN, stdout, arguments)
  stdout.rewind
  stdout.read
end
