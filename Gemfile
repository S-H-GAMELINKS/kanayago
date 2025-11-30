# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in kanayago.gemspec
gemspec

gem 'rake', '~> 13.3'
gem 'rake-compiler'

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-on-rbs', require: false
  gem 'rubocop-rake', require: false

  gem 'debug'
  gem 'typeprof'
end

group :test do
  gem 'minitest', require: false
  gem 'test-queue', require: false
end
