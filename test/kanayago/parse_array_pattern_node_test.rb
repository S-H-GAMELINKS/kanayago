# frozen_string_literal: true

require_relative '../test_helper'

class ParseArrayPatternNodeTest < Minitest::Test
  def test_parse_simple_array_pattern
    result = Kanayago.parse('case [1, 2]; in [a, b]; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body
    array_pattern = in_node.head

    assert_instance_of(Kanayago::ArrayPatternNode, array_pattern)
    assert_nil(array_pattern.pconst)
    assert_instance_of(Kanayago::ListNode, array_pattern.pre_args)
    assert_nil(array_pattern.rest_arg)
    assert_nil(array_pattern.post_args)
  end

  def test_parse_array_pattern_with_rest
    result = Kanayago.parse('case [1, 2, 3]; in [*, a, b]; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body
    array_pattern = in_node.head

    assert_instance_of(Kanayago::ArrayPatternNode, array_pattern)
    assert_nil(array_pattern.pre_args)
    # rest_arg is NODE_SPECIAL_NO_NAME_REST (special value)
    refute_nil(array_pattern.rest_arg)
    assert_instance_of(Kanayago::ListNode, array_pattern.post_args)
  end

  def test_parse_array_pattern_with_pre_and_post
    result = Kanayago.parse('case [1, 2, 3, 4]; in [a, *, b]; end')

    scope = result.ast
    case3_node = scope.body
    in_node = case3_node.body
    array_pattern = in_node.head

    assert_instance_of(Kanayago::ArrayPatternNode, array_pattern)
    assert_instance_of(Kanayago::ListNode, array_pattern.pre_args)
    refute_nil(array_pattern.rest_arg)
    assert_instance_of(Kanayago::ListNode, array_pattern.post_args)
  end
end
