# frozen_string_literal: true

require_relative 'lib/kanayago/version'

RUBY_PARSER_FILES = %w[
  ccan/check_type/check_type.h
  ccan/container_of/container_of.h
  ccan/list/list.h
  ccan/str/str.h
  constant.h
  id.h
  id_table.h
  include/ruby/st.h
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
  internal/set_table.h
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
  probes.h
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

Gem::Specification.new do |spec|
  spec.name = 'kanayago'
  spec.version = Kanayago::VERSION
  spec.authors = ['S-H-GAMELINKS']
  spec.email = ['gamelinks007@gmail.com']

  spec.summary = "Trying to Make Ruby's Parser Available as a Gem"
  spec.description = "Trying to Make Ruby's Parser Available as a Gem"
  spec.homepage = 'https://github.com/S-H-GAMELINKS/kanayago'
  spec.license = 'MIT'
  spec.required_ruby_version = '> 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/S-H-GAMELINKS/kanayago'
  spec.metadata['changelog_uri'] = 'https://github.com/S-H-GAMELINKS/kanayago/releases'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile ext/kanayago/parse.y])
    end
  end

  RUBY_PARSER_FILES.each do |file|
    files << "ext/kanayago/#{file}"
  end
  spec.files = files
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions = ['ext/kanayago/extconf.rb']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
