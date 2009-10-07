require 'csv'

class Processor

  class << self
    def init
      @qif = QIF.new
    end

    def process arguments, options
      if arguments.empty?
        process_file STDIN, STDOUT, options
      else
        arguments.each do |file|
          stream_in = File.open(file, "r")
          stream_out = File.new(basename(file, ".csv", ".CSV")+'.qif', "w")
          begin
            process_file stream_in, stream_out, options
          ensure
            stream_in.close
            stream_out.close
          end
        end
      end
    end

    private

    def process_file in_stream, out_stream, options
      @qif.reset out_stream, options
      rownum = 0
      CSV::Reader.parse(in_stream, options[:field_separator]) do |row|
        rownum += 1
        @qif.header row if rownum == options[:header]
        @qif.push row if rownum > options[:header]
      end
    end

    def basename file, *suffix
      suffix.map {|s| File.basename file, s}.sort.first
    end
  end
end