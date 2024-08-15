# frozen_string_literal: true

require_relative 'lib/mjollnir/version'

Gem::Specification.new do |spec|
  spec.name = 'mjollnir'
  spec.version = Mjollnir::VERSION
  spec.authors = ['S-H-GAMELINKS']
  spec.email = ['gamelinks007@gmail.com']

  spec.summary = 'Trying to Make Ruby's Parser Available as a Gem'
  spec.description = 'Trying to Make Ruby's Parser Available as a Gem'
  spec.homepage = 'https://github.com/S-H-GAMELINKS/mjollnir'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://github.com/S-H-GAMELINKS/mjollnir'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/S-H-GAMELINKS/mjollnir'
  spec.metadata['changelog_uri'] = 'https://github.com/S-H-GAMELINKS/mjollnir/releases'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  files << 'ext/mjollnir/parse.c'
  files << 'ext/mjollnir/parse.h'
  spec.files = files
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions = ['ext/mjollnir/extconf.rb']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
