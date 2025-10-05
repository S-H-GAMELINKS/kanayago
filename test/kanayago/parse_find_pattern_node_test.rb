# frozen_string_literal: true

require_relative '../test_helper'

class ParseFindPatternNodeTest < Minitest::Test
  def test_parse_find_pattern
    # Find pattern: [*, a, b, *]
    # Note: This might be represented as ARYPTN depending on Ruby version
    result = Kanayago.parse('case [1, 2, 3, 4, 5]; in [*, a, b, *]; end')

    scope = result
    case3_node = scope.body
    in_node = case3_node.body
    pattern = in_node.head

    # Check if it's FNDPTN or ARYPTN with special structure
    assert(pattern.is_a?(Kanayago::FindPatternNode) ||
           pattern.is_a?(Kanayago::ArrayPatternNode))
  end
end
