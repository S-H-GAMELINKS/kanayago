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
  desc 'import ruby parser files'
  task :import do
    tar_name = if RUBY_DESCRIPTION.include?('dev')
                 'snapshot/snapshot-master.tar.gz'
               else
                 "#{RUBY_VERSION[0..2]}/ruby-#{RUBY_VERSION}.tar.gz"
               end

    `mkdir -p tmp/ruby`
    `curl -L https://cache.ruby-lang.org/pub/ruby/#{tar_name} -o tmp/ruby.tar.gz`
    `tar -zxvf tmp/ruby.tar.gz -C tmp/ruby --strip-components 1`

    dist = File.expand_path('ext/kanayago', __dir__)
    ruby_dir = File.expand_path('tmp/ruby', __dir__)

    MAKE_DIRECTORIES.each do |dir|
      Dir.mkdir File.join(dist, dir) unless Dir.exist? dir
    end

    RUBY_PARSER_COPY_TARGETS.each do |target|
      FileUtils.cp File.join(ruby_dir, target), File.join(dist, target)
    end

    # "probes.h"
    probes_h_path = File.join(dist, 'probes.h')
    File.open(probes_h_path, 'w+') do |f|
      f << <<~SRC
        #define RUBY_DTRACE_PARSE_BEGIN_ENABLED() (0)
        #define RUBY_DTRACE_PARSE_BEGIN(arg0, arg1) (void)(arg0), (void)(arg1);
        #define RUBY_DTRACE_PARSE_END_ENABLED() (0)
        #define RUBY_DTRACE_PARSE_END(arg0, arg1) (void)(arg0), (void)(arg1);
      SRC
    end

    `rm -rf tmp/ruby tmp/ruby.tar.gz`
  end

  desc 'patched ro ruby parse that build for Kanayago'
  task :patch do
    running_ruby_version = if RUBY_DESCRIPTION.include?('dev')
                             'head'
                           else
                             RUBY_VERSION[..2]
                           end

    sh "patch -p1 < patch/#{running_ruby_version}/kanayago.patch"
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

task build: ['ruby_parser:import', 'ruby_parser:patch', 'compile']
task install: ['ruby_parser:import', 'ruby_parser:patch', 'compile']

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

desc 'try to kanayago code'
task :run do
  sh 'ruby test.rb'
end

desc 'debug to kanayago code in gdb'
task :gdb do
  sh 'bundle exec gdb --args ruby test.rb'
end

task default: %i[clobber compile]
