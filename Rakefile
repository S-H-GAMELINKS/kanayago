# frozen_string_literal: true

require 'English'
require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rake/testtask'
require 'test_queue'
require 'test_queue/runner/minitest'
require 'fileutils'

if RUBY_DESCRIPTION.include?('dev')
  require_relative 'patch/head/copy_target'
else
  require_relative "patch/#{RUBY_VERSION}/copy_target"
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
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/integration/**/*_test.rb')
end

INTEGRATION_TEST_TARGET_REPOS_DIR = File.expand_path('tmp/integration_repos', __dir__)
INTEGRATION_TEST_TARGET_REPOSITORIES = {
  'rails' => {
    url: 'https://github.com/rails/rails.git',
    branch: 'main',
    depth: 1
  },
  'discourse' => {
    url: 'https://github.com/discourse/discourse.git',
    branch: 'main',
    depth: 1
  },
  'mastodon' => {
    url: 'https://github.com/mastodon/mastodon.git',
    branch: 'main',
    depth: 1
  },
  'gitlab' => {
    url: 'https://gitlab.com/gitlab-org/gitlab.git',
    branch: 'master',
    depth: 1
  }
}.freeze

namespace :integration do
  desc 'Setup integration test repositories'
  task :setup do
    FileUtils.mkdir_p(INTEGRATION_TEST_TARGET_REPOS_DIR)

    INTEGRATION_TEST_TARGET_REPOSITORIES.each do |name, config|
      repo_path = File.join(INTEGRATION_TEST_TARGET_REPOS_DIR, name)

      if File.directory?(repo_path)
        puts "Repository #{name} already exists at #{repo_path}"
        next
      end

      puts "Cloning #{name} from #{config[:url]}..."
      system("git clone --depth #{config[:depth]} --branch #{config[:branch]} #{config[:url]} #{repo_path}")

      if $CHILD_STATUS.success?
        puts "Successfully cloned #{name}"
      else
        puts "Failed to clone #{name}"
      end
    end

    puts "\nIntegration test repositories setup complete!"
  end

  desc 'Clean integration test repositories'
  task :clean do
    if File.directory?(INTEGRATION_TEST_TARGET_REPOS_DIR)
      puts "Removing integration test repositories at #{INTEGRATION_TEST_TARGET_REPOS_DIR}..."
      FileUtils.rm_rf(INTEGRATION_TEST_TARGET_REPOS_DIR)
      puts 'Done!'
    else
      puts 'No integration test repositories found'
    end
  end

  desc 'Update integration test repositories'
  task :update do
    unless File.directory?(INTEGRATION_TEST_TARGET_REPOS_DIR)
      puts "No repositories found. Run 'rake integration:setup' first."
      next
    end

    INTEGRATION_TEST_TARGET_REPOSITORIES.each_key do |name|
      repo_path = File.join(INTEGRATION_TEST_TARGET_REPOS_DIR, name)

      unless File.directory?(repo_path)
        puts "Repository #{name} not found, skipping..."
        next
      end

      puts "Updating #{name}..."
      Dir.chdir(repo_path) do
        system('git pull')
      end
    end

    puts "\nIntegration test repositories updated!"
  end

  desc 'Run integration tests'
  Rake::TestTask.new(:test) do |t|
    t.libs << 'test'
    t.libs << 'lib'
    t.test_files = FileList['test/integration/**/*_test.rb']
    t.verbose = true
  end
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
