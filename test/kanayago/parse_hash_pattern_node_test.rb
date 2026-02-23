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

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      case {x: 1}; in {x: a}; end
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
