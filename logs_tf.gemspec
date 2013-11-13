# -*- encoding: utf-8 -*-
require File.expand_path('../lib/logs_tf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'logs_tf'
  gem.version       = LogsTF::VERSION
  gem.date          = '2013-11-13'
  gem.summary       = "Logs.tf"
  gem.description   = "A gem to interface with the logs.tf API"
  gem.authors       = ["Arie"]
  gem.email         = 'rubygems@ariekanarie.nl'
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.homepage      = 'http://github.com/Arie/logs_tf'

  gem.add_dependency "faraday",         "~> 0.8.0"
  gem.add_dependency "multipart-post",  "~> 1.2.0"

  gem.add_development_dependency "vcr"
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "rspec"
end
