gem_version = File.read("VERSION").strip
gem_name = "lazy-sax-machine"

require "rspec/core/rake_task"
# require File.dirname(__FILE__) + '/lib/sax-machine.rb'


task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
end


desc "Build the gem"
task :build do
  system "gem build #{gem_name}.gemspec"
end
 
desc "Build and push the gem to rubygems.org"
task :release => :build do
  system "gem push #{gem_name}-#{gem_version}.gem"
end

desc "Build and install the gem"
task :install => :build do
  system "gem install #{gem_name}-#{gem_version}.gem"
end


desc "Load this checked out git repo in pry"
task :pry do
  system "pry --gem"
end

