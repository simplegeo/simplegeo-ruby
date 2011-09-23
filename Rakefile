require 'rake'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = "--sort coverage --exclude gems,spec"
end

task :default => :spec

require 'simple_geo'
require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = SimpleGeo::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "simplegeo-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
