require 'bundler'
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

desc 'Run the specs'
RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

require 'rdoc/task'
require 'simple_geo/version'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "simplegeo-ruby #{SimpleGeo::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

