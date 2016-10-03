# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_fresh/version'

Gem::Specification.new do |spec|
  spec.name          = "gem_fresh"
  spec.version       = GemFresh::VERSION
  spec.authors       = ["Anne Geiersbach", "Parker Morse"]
  spec.email         = ["annasazi@gmail.com", "flashesofpanic@gmail.com"]

  spec.summary       = %q{Quantifying the freshness of your gems.}
  spec.description   = %q{Uses Bundler's "outdated" function and some ranking of your gems to generate a score for how significantly you're behind on updating gems.}
  spec.homepage      = "https://github.com/dmcouncil/gem_fresh"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.9"
  spec.add_dependency "rake", "~> 10.0"
end
