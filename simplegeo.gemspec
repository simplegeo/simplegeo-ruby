# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'simple_geo/version'

Gem::Specification.new do |gem|
  gem.add_development_dependency 'rspec', ">= 1.2.0"
  gem.add_development_dependency 'fakeweb', ">= 1.2.0"
  gem.add_development_dependency 'vcr', ">= 1.6.0"
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rdoc'
  gem.add_runtime_dependency 'oauth', ">= 0.4.0"
  gem.add_runtime_dependency 'json_pure', ">= 0"

  gem.authors = ["Brian Ryckbost", "Andrew Mager"]
  gem.summary = 'A SimpleGeo Ruby Client'
  gem.email = ['andrew@simplegeo.com']
  gem.extra_rdoc_files = ["LICENSE","README.rdoc"]
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'http://github.com/simplegeo/simplegeo-ruby'
  gem.rdoc_options = ["--charset=UTF-8"]
  gem.name = 'simplegeo'
  gem.require_paths = ["lib"]
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.test_files = `git ls-files -- spec/*`.split("\n")
  gem.version = SimpleGeo::VERSION
end
