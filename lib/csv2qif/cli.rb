require 'optparse'

module Csv2qif
  class CLI
    DEFAULT_OPTIONS = {
            :field_separator => ',',
            :header => 1,
            :date => "a",
            :amount => "b",
            :type => 'CCard'

    }

    def self.execute(stdin, stdout, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {

              }

      mandatory_options = %w(  )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /, '')
          cvs2qif -- format converter

          Usage: #{File.basename($0)} [options] [file...]

          The csv2qif utility reads the specified csv files, or the standard input if no files are specified,
          converting the input to qif format. The output is written to either the standart output if read from
          standard input or file with the same base name as input and qif extension or to a file specified as an
          option.

          The CONDITION and COLUMN below are in the simplest case represented by just one lower case letter (a-z) indicating the the csv column
          which should be mapped to a particular line in a qif record. As a minimum a date and amount column should be mapped
          e.g.
          #> csv2qif -D a --amount b file.csv
          will assume the first column (a) in the csv file is date and  second (b) the amount. Those are as well defaults.
          CONDITION and COLUMNS may as well be any ruby expression. In this case the expression will be evaluated in a context
          in which the column names (a-z) are available as methods returning the value in the corresponding column or nil if empty.

          Options are:
        BANNER
        opts.separator ""
        opts.on("-b", "--bundle BUNDLE", String,
                 "Name of an option bundle",
                 "Default: default") { |arg| options[:bundle] = arg }
        opts.on("-t", "--type Type", ['CCard', 'Bank', 'Cash'],
                 "Type of acoount: CCard, Bank or Cash",
                 "Default: CCard") { |arg| options[:type] = arg }
         opts.on("-w", "--where CONDITION",
                "only records satisfying CONDITION will be converted") { |arg| options[:where] = arg }
        opts.on("-s", "--field_separator SEPARATOR",
                "field seprator. Default: ,") { |arg| options[:where] = arg }
        opts.on("-m", "--mappings MAPPINGS",
                "comma separated list of mappings in the format: /pattern/replacement/",
                "Use for modifying categories") { |arg| options[:mappings] = arg.split "," }
        opts.on("-d", "--header N", Integer,
                "number of rows occupied by headers before actual data") { |arg| options[:header] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; return }
        opts.separator " "
        
        opts.separator "QIF Record options:"
        QIF::QIF_CODES.each do |key, code, description|
           opts.on("-#{code}", "--#{key} COLUMN", String, description || key.to_s.capitalize) {|arg| options[key]=arg}
        end

        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      options = prepare_options stdout, options, Processor.init
      prepare_mappings options

      Processor.process stdin, stdout, arguments, options
    end

    private
    def self.load_yml file, qif=nil
      symbolize_keys YAML.load_file(file)
    end

    def self.load_rb file, qif
      eval File.read(file), qif.block
    end

    def self.prepare_options stdout, options, qif
      if h = options[:bundle] ? load_file(options[:bundle], qif) : {}
        DEFAULT_OPTIONS.merge(h).merge options
      else
        stdout.puts("Specified bundle '#{options[:bundle]}' does not exist")
        exit
      end
    end

    def self.load_file bundle, qif=nil
      ['.', File.join( File.dirname(__FILE__), "../../config")].each do |dir|
        [:rb, :yml].each do |type|
          if h = (File.exists?(file=File.join(dir, [bundle, type].join('.'))) and send "load_#{type}".to_sym, file, qif)
            return h
          end
        end
      end
      nil
    end

    def self.symbolize_keys hash
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end

    def self.prepare_mappings options
      options[:mappings] = options[:mappings].map do |m|
        m = m.split(m[0,1])[1,3] unless m.instance_of? Array
        m.unshift true if m.length < 3
        m[1]=Regexp.new(m[1])
        m
      end if options[:mappings]
    end
  end

end