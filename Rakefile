# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rake/testtask'
require 'test_queue'
require 'test_queue/runner/minitest'
require 'fileutils'

COPY_TARGETS = %w[
  ccan/check_type/check_type.h
  ccan/container_of/container_of.h
  ccan/list/list.h
  ccan/str/str.h
  constant.h
  id.h
  id_table.h
  internal/array.h
  internal/basic_operators.h
  internal/bignum.h
  internal/bits.h
  internal/compile.h
  internal/compilers.h
  internal/complex.h
  internal/encoding.h
  internal/error.h
  internal/fixnum.h
  internal/gc.h
  internal/hash.h
  internal/imemo.h
  internal/io.h
  internal/numeric.h
  internal/parse.h
  internal/rational.h
  internal/re.h
  internal/ruby_parser.h
  internal/sanitizers.h
  internal/serial.h
  internal/static_assert.h
  internal/string.h
  internal/symbol.h
  internal/thread.h
  internal/variable.h
  internal/warnings.h
  internal/vm.h
  internal.h
  lex.c
  method.h
  node.c
  node.h
  node_name.inc
  parse.c
  parse.h
  parser_bits.h
  parser_node.h
  parser_st.c
  parser_st.h
  parser_value.h
  ruby_assert.h
  ruby_atomic.h
  ruby_parser.c
  rubyparser.h
  shape.h
  st.c
  symbol.h
  thread_pthread.h
  universal_parser.c
  vm_core.h
  vm_opts.h
].freeze

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

    directories = ['ccan', 'ccan/check_type', 'ccan/container', 'ccan/container_of', 'ccan/list', 'ccan/str',
                   'internal']

    directories.each do |dir|
      Dir.mkdir File.join(dist, dir) unless Dir.exist? dir
    end

    COPY_TARGETS.each do |target|
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

    COPY_TARGETS.each do |target|
      FileUtils.rm File.join(dist, target), force: true
    end
    delete_files = ['constant.h', 'id.h', 'id.h', 'id.h', 'id_table.h', 'lex.c', 'node_name.inc', 'parse.c', 'parse.h',
                    'parse.y', 'parse.tmp.y', 'probes.h', 'shape.h']

    delete_files.each do |file|
      FileUtils.rm File.join(dist, file), force: true
    end

    delete_directories = %w[ccan internal]

    delete_directories.each do |dir|
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
