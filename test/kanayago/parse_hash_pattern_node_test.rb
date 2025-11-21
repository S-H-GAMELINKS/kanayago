# frozen_string_literal: true

require_relative '../test_helper'

class ParseHashPatternNodeTest < Minitest::Test
  def test_parse_simple_hash_pattern
    result = Kanayago.parse('case {x: 1}; in {x: a}; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body
    hash_pattern = in_node.head

    assert_instance_of(Kanayago::HashPatternNode, hash_pattern)
    assert_nil(hash_pattern.pconst)
    assert_instance_of(Kanayago::HashNode, hash_pattern.pkwargs)
    assert_nil(hash_pattern.pkwrestarg)
  end

  def test_parse_hash_pattern_with_multiple_keys
    result = Kanayago.parse('case {x: 1, y: 2}; in {x: a, y: b}; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body
    hash_pattern = in_node.head

    assert_instance_of(Kanayago::HashPatternNode, hash_pattern)
    assert_instance_of(Kanayago::HashNode, hash_pattern.pkwargs)
  end
end
