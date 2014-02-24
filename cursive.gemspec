# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cursive/version'

Gem::Specification.new do |spec|
  spec.name          = "cursive"
  spec.version       = Cursive::VERSION
  spec.authors       = ["Mike Owens"]
  spec.email         = ["mike@filespanker.com"]
  spec.summary       = %q{Rails CSV Responder in the style of AM::S}
  spec.description   = %q{Declarative CSV responders for Rails}
  spec.homepage      = "https://github.com/mieko/cursive"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '> 2.1'

  spec.add_dependency "rails", '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.2"
end
