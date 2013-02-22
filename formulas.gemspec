# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formulas/version'

Gem::Specification.new do |gem|
  gem.name          = "formulas"
  gem.version       = Formulas::VERSION
  gem.authors       = ["Federico Ravasio"]
  gem.email         = ["ravasio.federico@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/razielgn/formulas"

  gem.files         = Dir.glob('lib/**/*')
  gem.require_paths = ["lib"]
end
