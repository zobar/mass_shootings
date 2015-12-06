$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'mass_shootings/gemspec'
require 'rake/testtask'
require 'rubygems/package_task'
require 'yard'

Gem::PackageTask.new(MassShootings.gemspec) {}

Rake::TestTask.new do |t|
  t.libs << 'spec'
  t.test_files = FileList['spec/**/*_spec.rb']
end

YARD::Rake::YardocTask.new

task :clean do
  rm_rf FileList['coverage', 'doc', 'pkg', '.yardoc']
end

task default: :test
