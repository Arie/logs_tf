# -*- encoding: utf-8 -*-
require File.expand_path('../lib/logs_tf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'logs_tf'
  gem.version       = LogsTF::VERSION
  gem.date          = '2013-02-10'
  gem.summary       = "Logs.tf"
  gem.description   = "A gem to interface with the logs.tf API"
  gem.authors       = ["Arie"]
  gem.email         = 'rubygems@ariekanarie.nl'
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.homepage      = 'http://github.com/Arie/logs_tf'
end
