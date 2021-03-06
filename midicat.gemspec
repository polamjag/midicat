# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'midicat/version'

Gem::Specification.new do |spec|
  spec.name          = "midicat"
  spec.version       = Midicat::VERSION
  spec.authors       = ["polamjag"]
  spec.email         = ["s@polamjag.info"]
  spec.summary       = %q{pretty cat/tailf-like command for midi inputs}
  spec.homepage      = "https://github.com/polamjag/midicat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_dependency 'unimidi'
  spec.add_dependency 'midi-nibbler'
end
