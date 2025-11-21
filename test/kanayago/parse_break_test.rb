# frozen_string_literal: true

require_relative '../test_helper'

class ParseBreakTest < Minitest::Test
  def test_parse_break_basic
    result = Kanayago.parse('loop { break }')

    scope = result.ast

    assert_instance_of(Kanayago::ScopeNode, scope)

    iter = scope.body

    assert_instance_of(Kanayago::IterNode, iter)

    iter_body = iter.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)

    break_node = iter_body.body

    assert_instance_of(Kanayago::BreakNode, break_node)
    assert_nil(break_node.statements)
  end

  def test_parse_break_with_value
    result = Kanayago.parse('loop { break 117 }')

    scope = result.ast
    iter = scope.body
    iter_body = iter.body
    break_node = iter_body.body

    assert_instance_of(Kanayago::BreakNode, break_node)
    assert_instance_of(Kanayago::IntegerNode, break_node.statements)
  end

  def test_parse_break_with_multiple_values
    result = Kanayago.parse('loop { break 1, 2 }')

    scope = result.ast
    iter = scope.body
    iter_body = iter.body
    break_node = iter_body.body

    assert_instance_of(Kanayago::BreakNode, break_node)
    assert_instance_of(Kanayago::ListNode, break_node.statements)
    assert_equal(2, break_node.statements.val.length)
  end

  def test_parse_break_conditional
    result = Kanayago.parse('loop { break if true }')

    scope = result.ast
    iter = scope.body
    iter_body = iter.body
    if_node = iter_body.body

    assert_instance_of(Kanayago::IfStatementNode, if_node)

    break_node = if_node.body

    assert_instance_of(Kanayago::BreakNode, break_node)
    assert_nil(break_node.statements)
  end

  def test_parse_break_in_iterator
    result = Kanayago.parse('[1, 2, 3].each { |i| break }')

    scope = result.ast
    iter = scope.body

    assert_instance_of(Kanayago::IterNode, iter)

    iter_body = iter.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)

    break_node = iter_body.body

    assert_instance_of(Kanayago::BreakNode, break_node)
    assert_nil(break_node.statements)
  end
end
