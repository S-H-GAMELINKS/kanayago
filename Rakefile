# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"

task build: :compile

GEMSPEC = Gem::Specification.load("mjollnir.gemspec")

Rake::ExtensionTask.new("mjollnir", GEMSPEC) do |ext|
  ext.lib_dir = "lib/mjollnir"
end

task default: %i[clobber compile]
