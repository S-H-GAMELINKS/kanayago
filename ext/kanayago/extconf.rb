# frozen_string_literal: true

require 'mkmf'

# Run setup script to prepare Ruby parser files before building
setup_script = File.expand_path('../../script/setup_parser.rb', __dir__)
puts 'Running parser setup script...'
unless system("ruby #{setup_script}")
  warn 'Failed to setup parser files. Please check the error messages above.'
  exit 1
end

$objs = %w[
  node
  parse
  parser_st
  ruby_parser
  kanayago
  scope_node
  literal_node
  string_node
  statement_node
  variable_node
  pattern_node
].map do |o|
  o + ".#{$OBJEXT}"
end

append_cflags('-fvisibility=hidden')
append_cppflags('-DUNIVERSAL_PARSER=1')

$INCFLAGS << ' -I' << File.expand_path('../kanayago', __dir__)
$INCFLAGS << ' -I' << File.expand_path('../..', __dir__)

create_makefile('kanayago/kanayago')
