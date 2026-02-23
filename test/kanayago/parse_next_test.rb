# frozen_string_literal: true

require_relative '../test_helper'

class ParseNextTest < Minitest::Test
  def test_parse_next_basic
    result = Kanayago.parse('loop { next }')

    scope = result.ast

    assert_instance_of(Kanayago::ScopeNode, scope)

    iter = scope.body

    assert_instance_of(Kanayago::IterNode, iter)

    iter_body = iter.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)

    next_node = iter_body.body

    assert_instance_of(Kanayago::NextNode, next_node)
    assert_nil(next_node.statements)
  end

  def test_parse_next_with_value
    result = Kanayago.parse('loop { next 117 }')

    scope = result.ast
    iter = scope.body
    iter_body = iter.body
    next_node = iter_body.body

    assert_instance_of(Kanayago::NextNode, next_node)
    assert_instance_of(Kanayago::IntegerNode, next_node.statements)
  end

  def test_parse_next_with_multiple_values
    result = Kanayago.parse('loop { next 1, 2 }')

    scope = result.ast
    iter = scope.body
    iter_body = iter.body
    next_node = iter_body.body

    assert_instance_of(Kanayago::NextNode, next_node)
    assert_instance_of(Kanayago::ListNode, next_node.statements)
    assert_equal(2, next_node.statements.val.length)
  end

  def test_parse_next_conditional
    result = Kanayago.parse('loop { next if true }')

    scope = result.ast
    iter = scope.body
    iter_body = iter.body
    if_node = iter_body.body

    assert_instance_of(Kanayago::IfStatementNode, if_node)

    next_node = if_node.body

    assert_instance_of(Kanayago::NextNode, next_node)
    assert_nil(next_node.statements)
  end

  def test_parse_next_in_iterator
    result = Kanayago.parse('[1, 2, 3].each { |i| next }')

    scope = result.ast
    iter = scope.body

    assert_instance_of(Kanayago::IterNode, iter)

    iter_body = iter.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)

    next_node = iter_body.body

    assert_instance_of(Kanayago::NextNode, next_node)
    assert_nil(next_node.statements)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      loop { next }
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::IterNode
      assert_instance_of(Kanayago::IterNode, body)
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

    body in Kanayago::IterNode

    assert_instance_of(Kanayago::IterNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::IterNode

    assert_instance_of(Kanayago::IterNode, body)
  end
end
