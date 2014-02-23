require "bundler/gem_tasks"
require "rake/testtask"

# This assumes irb, because pry has the awesome `pry --gem`
task :console do
  require 'irb'
  require 'irb/completion'
  $LOAD_PATH.unshift File.expand_path('./lib', __FILE__)

  require 'cursive'

  ARGV.clear
  IRB.start
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
end

task :default => :test
