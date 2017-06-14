# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pronto/dialyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "pronto-dialyzer"
  spec.version       = Pronto::Dialyzer::VERSION
  spec.authors       = ["Iuri Fernandes"]
  spec.email         = ["iurifq@gmail.com"]

  spec.summary       = %q{Pronto runner for Dialyzer}
  spec.description   = %q{This allows you to take the output of Dialyzer and submit its errors with Pronto.}
  spec.homepage      = "https://github.com/iurifq/pronto-dialyzer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'pronto', '>= 0.6.0', '< 0.10.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
