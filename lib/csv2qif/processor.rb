require 'csv'

class Processor

  class << self
    def init
      @qif = QIF.new
    end

    def process stdin, stdout, arguments, options
      if arguments.empty?
        process_file stdin, stdout, options
      else
        arguments.each do |file|
          stream_in = File.open(file, "r")
          stream_out = File.new esub(file, :csv, :qif), "w"
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

    def esub file, old, new
       file.gsub(/\.#{old}$/i, '')+".#{new}"
    end

    def process_file in_stream, out_stream, options
      @qif.reset out_stream, options
      rownum = 0
      CSV.new(in_stream, :col_sep => options[:field_separator]).each do |row|
        rownum += 1
        @qif.header row if rownum == options[:header]
        @qif.push row if rownum > options[:header]
      end
    end
  end
end