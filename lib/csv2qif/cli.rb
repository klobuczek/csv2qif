require 'optparse'

module Csv2qif
  class CLI
    DEFAULT_OPTIONS = {
            :row_separator => ',',
            :header => 0
    }
    
    def self.execute(stdout, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
              :bundle     => 'default',
      }
      
      mandatory_options = %w(  )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /, '')
          cvs2qif -- format converter

          Usage: #{File.basename($0)} [options] [file...]

          The csv2qif utility reads the specified csv files, or the standard input if no files are specified,
          converting the input to qif format. The output is written to the standart output.

          Options are:
        BANNER
        opts.separator ""
        opts.on("-b", "--bundle BUNDLE", String,
                "Name of an option bundle",
                "Default: default") { |arg| options[:bundle] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; return }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      options = prepare_options stdout, options
      prepare_mappings options

      Processor.process arguments, options
    end

    def self.load_symbolized file
      symbolize_keys YAML.load_file(file)
    end

    private
    def self.prepare_options stdout, options
        File.exists?(bf=File.join(File.dirname(__FILE__),"../../config/#{options[:bundle]}.yml")) ||
        File.exists?(bf=options[:bundle]) ||
        File.exists?(bf=(options[:bundle]+".yml")) ||
        (stdout.puts("Specified bundle '#{bundle}' does not exist"); exit )
        DEFAULT_OPTIONS.merge(load_symbolized bf).merge options
    end

    def self.symbolize_keys hash
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end 
    
    def self.prepare_mappings options
       options[:mappings] = options[:mappings].map do |m|
         pattern, replacement = m.split('/')[1,2]
         [Regexp.new(pattern), replacement]
       end if options[:mappings]
    end
  end

end