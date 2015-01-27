# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fixed_width_columns/version'

Gem::Specification.new do |spec|
  spec.name          = "fixed_width_columns"
  spec.version       = FixedWidthColumns::VERSION
  spec.authors       = ["Conan Dalton"]
  spec.email         = ["conan@conandalton.net"]
  spec.summary       = %q{Generate fixed-width-column textfiles quickly and easily}
  spec.description   = %q{Specify attribute, width, alignment, and padding for each column and call #format and you're good}
  spec.homepage      = "https://github.com/conanite/fixed_width_columns"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             'aduki'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_numbering_formatter'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
