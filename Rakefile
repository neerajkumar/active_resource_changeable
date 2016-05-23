require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -Ilib -ractive_resource_changeable"
end
