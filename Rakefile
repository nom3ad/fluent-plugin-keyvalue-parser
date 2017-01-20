# encoding: utf-8
require "bundler/gem_tasks"

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) {| spec |
    spec.pattern = FileList['spec/*_spec.rb']
}
task :default => :spec
