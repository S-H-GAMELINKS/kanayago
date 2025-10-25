# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rake/testtask'
require 'test_queue'
require 'test_queue/runner/minitest'
require 'fileutils'

if RUBY_DESCRIPTION.include?('dev')
  require_relative 'patch/head/copy_target'
else
  require_relative "patch/#{RUBY_VERSION[0..2]}/copy_target"
end

namespace :ruby_parser do
  desc 'import ruby parser files and apply patch'
  task :setup do
    sh 'ruby script/setup_parser.rb'
  end

  desc 'clean to ruby parser file'
  task :clean do
    dist = File.expand_path('./ext/kanayago')

    RUBY_PARSER_COPY_TARGETS.each do |target|
      FileUtils.rm File.join(dist, target), force: true
    end
    delete_files = ['constant.h', 'id.h', 'id.h', 'id.h', 'id_table.h', 'lex.c', 'node_name.inc', 'parse.c', 'parse.h',
                    'parse.y', 'parse.tmp.y', 'probes.h', 'shape.h']

    delete_files.each do |file|
      FileUtils.rm File.join(dist, file), force: true
    end

    DELETE_DIRECTORIES.each do |dir|
      FileUtils.rm_rf File.join(dist, dir)
    end
  end
end

task :build # rubocop:disable Rake/Desc
task install: ['ruby_parser:clean', 'ruby_parser:setup', 'compile']

GEMSPEC = Gem::Specification.load('kanayago.gemspec')

Rake::ExtensionTask.new('kanayago', GEMSPEC) do |ext|
  ext.lib_dir = 'lib/kanayago'
end

namespace :queue do
  desc 'run test with test-queue'
  task :test do
    sh 'bundle exec minitest-queue $(find test/ -name \*_test.rb)'
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :sample do
  desc 'Generate RSpec tests from Ruby code using Kanayago AST'
  task :rspec_generate do
    sh 'ruby sample/test_generator.rb'
  end

  desc 'Generate Minitest tests from Ruby code using Kanayago AST'
  task :minitest_generate do
    sh 'ruby sample/minitest_generator.rb'
  end
end

desc 'try to kanayago code'
task :run do
  sh 'ruby test.rb'
end

desc 'debug to kanayago code in gdb'
task :gdb do
  sh 'bundle exec gdb --args ruby test.rb'
end

task default: %i[clobber compile]
