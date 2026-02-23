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

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      case [1, 2]; in [a, b]; end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::Case3Node
      assert_instance_of(Kanayago::Case3Node, body)
    end
  end

  def test_case_in_unmatched
    body = pattern_match_target_body

    assert_raises(NoMatchingPatternError) do
      case body.class.name
      in '__kanayago_unmatched_pattern__'
        # Nothing to do
      end
    end
  end

  def test_single_in
    body = pattern_match_target_body

    body in Kanayago::Case3Node

    assert_instance_of(Kanayago::Case3Node, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::Case3Node

    assert_instance_of(Kanayago::Case3Node, body)
  end
end
