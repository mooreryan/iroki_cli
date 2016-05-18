# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iroki/version'

Gem::Specification.new do |spec|
  spec.name          = "iroki"
  spec.version       = Iroki::VERSION
  spec.authors       = ["Ryan Moore"]
  spec.email         = ["moorer@udel.edu"]

  spec.summary       = %q{Command line app and library code for Iroki, a phylogenetic tree customization program.}
  spec.description   = %q{Command line app and library code for Iroki, a phylogenetic tree customization program.}
  spec.homepage      = "https://github.com/mooreryan/iroki"
  spec.license       = "GPLv3: http://www.gnu.org/licenses/gpl.txt"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.4"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.6", ">= 4.6.4"
  spec.add_development_dependency "yard", "~> 0.8.7.6"
  spec.add_development_dependency "coveralls", "~> 0.8.11"

  spec.add_runtime_dependency "abort_if", "~> 0.1.0"
  spec.add_runtime_dependency "bio", "~> 1.5"
  spec.add_runtime_dependency "trollop", "~> 2.1", ">= 2.1.2"
end
