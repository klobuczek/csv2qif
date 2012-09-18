require "csv2qif/version"
require "csv2qif/defaults"
require "csv2qif/string_ext"
require "csv2qif/processor"
require "csv2qif/qif"

module Csv2qif
  autoload :CLI, 'csv2qif/cli'
  #autoload :Processor, 'csv2qif/processor'
  #autoload :QIF, 'csv2qif/qif'
end