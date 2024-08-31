# frozen_string_literal: true

require 'mkmf'

$objs = %w[
  node
  parse
  parser_st
  ruby_parser
  refine_tree
].map do |o|
  o + ".#{$OBJEXT}"
end

append_cflags('-fvisibility=hidden')
append_cppflags('-DUNIVERSAL_PARSER=1')

$INCFLAGS << ' -I' << File.expand_path('../refine_tree', __dir__)
$INCFLAGS << ' -I' << File.expand_path('../..', __dir__)

create_makefile('refine_tree/refine_tree')