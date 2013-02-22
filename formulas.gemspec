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

  gem.add_dependency 'shikashi',       '~> 0.5.0'
  gem.add_dependency 'activesupport',  '>= 3.0.0'
end
