# frozen_string_literal: true

require_relative '../test_helper'

class ParseFindPatternNodeTest < Minitest::Test
  def test_parse_find_pattern
    # Find pattern: [*, a, b, *]
    # Note: This might be represented as ARYPTN depending on Ruby version
    result = Kanayago.parse('case [1, 2, 3, 4, 5]; in [*, a, b, *]; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body
    pattern = in_node.head

    # Check if it's FNDPTN or ARYPTN with special structure
    assert(pattern.is_a?(Kanayago::FindPatternNode) ||
           pattern.is_a?(Kanayago::ArrayPatternNode))
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      case [1, 2, 3, 4, 5]; in [*, a, b, *]; end
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
