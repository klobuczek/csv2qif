# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv2qif/version'

Gem::Specification.new do |gem|
  gem.name          = "csv2qif"
  gem.version       = Csv2qif::VERSION
  gem.authors       = ["Heinrich Klobuczek"]
  gem.email         = ["heinrich@mail.com"]
  gem.description   = %q{Command line tool csv2qif}
  gem.summary       = %q{Converts csv files to qif according to provided configuration}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>=2.1.2'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
