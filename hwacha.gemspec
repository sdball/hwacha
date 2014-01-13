# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hwacha/version'

Gem::Specification.new do |spec|
  spec.name          = "hwacha"
  spec.version       = Hwacha::VERSION
  spec.authors       = ["Stephen Ball"]
  spec.email         = ["sdball@gmail.com"]
  spec.description   = %q{Harness the power of Typhoeus to quickly check webpage responses.}
  spec.summary       = %q{Sometimes you just want to check a bunch of webpages. Hwacha makes it easy.}
  spec.homepage      = "http://github.com/sdball/hwacha"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
end
