require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "simplegeo"
    gem.summary = %Q{A SimpleGeo Ruby Client}
    gem.email = "andrew@simplegeo.com"
    gem.homepage = "https://github.com/simplegeo/simplegeo-ruby"
    gem.authors = ["Dan Dofter", "Brian Ryckbost", "Andrew Mager", "Peter Bell"]

    gem.add_dependency("oauth", ">= 0.4.0")
    gem.add_dependency("json_pure")

    gem.add_development_dependency "rspec", ">= 1.2.0"
    gem.add_development_dependency("fakeweb", ">= 1.2.0")
    gem.add_development_dependency("vcr", ">= 1.6.0")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

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

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "simplegeo-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
