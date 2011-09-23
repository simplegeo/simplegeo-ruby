$: << File.expand_path(__FILE__ + '/../lib')
require 'simple_geo'
Gem::Specification.new do |s|
  s.name = %q{simplegeo}
  s.version = SimpleGeo::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Dofter", "Bryan Ryckbost", "Andrew Mager", "Peter Bell"]
  s.email = %q{andrew@simplegeo.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  
  ignoreable_commands = File.read('.gitignore').split("\n").delete_if{|line| line.match(/^##/) || line.empty? }
  ignoreable_files = ignoreable_commands.collect{|line| 
    if File.directory?(line)
      line + "/**/*"
    elsif File.file?(line)
      line
    end
  }.compact
  
  s.files = Dir['**/*','.gitignore'] - Dir[*ignoreable_files]
  
  s.homepage = %q{http://github.com/simplegeo/simplegeo-ruby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A SimpleGeo Ruby Client}
  s.test_files = Dir.glob('spec/*.rb')

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency('oauth', [">= 0.4.0"])
      s.add_runtime_dependency('json_pure', [">= 0"])
      s.add_development_dependency('rspec', [">= 1.2.0"])
      s.add_development_dependency('fakeweb', [">= 1.2.0"])
      s.add_development_dependency('vcr', [">= 1.6.0"])
    else
      s.add_dependency('oauth', [">= 0.4.0"])
      s.add_dependency('json_pure', [">= 0"])
      s.add_dependency('rspec', [">= 1.2.0"])
      s.add_dependency('fakeweb', [">= 1.2.0"])
      s.add_dependency('vcr', [">= 1.6.0"])
    end
  else
    s.add_dependency('oauth', [">= 0.4.0"])
    s.add_dependency('json_pure', [">= 0"])
    s.add_dependency('rspec', [">= 1.2.0"])
    s.add_dependency('fakeweb', [">= 1.2.0"])
    s.add_dependency('vcr', [">= 1.6.0"])
  end
end

