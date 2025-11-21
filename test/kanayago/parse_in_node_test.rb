# frozen_string_literal: true

require_relative '../test_helper'

class ParseInNodeTest < Minitest::Test
  def test_parse_in_node_with_array_pattern
    result = Kanayago.parse('case [1, 2]; in [a, b]; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body

    assert_instance_of(Kanayago::InNode, in_node)
    assert_instance_of(Kanayago::ArrayPatternNode, in_node.head)
    assert_instance_of(Kanayago::BeginNode, in_node.body)
  end

  def test_parse_in_node_with_hash_pattern
    result = Kanayago.parse('case {x: 1}; in {x: a}; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body

    assert_instance_of(Kanayago::InNode, in_node)
    assert_instance_of(Kanayago::HashPatternNode, in_node.head)
  end

  def test_parse_multiple_in_nodes
    result = Kanayago.parse('case [1, 2]; in [1, x]; in [a, b]; end')

    scope = result.ast
    case3_node = scope.body
    first_in = case3_node.body

    assert_instance_of(Kanayago::InNode, first_in)
    assert_instance_of(Kanayago::InNode, first_in.next)
  end
end
