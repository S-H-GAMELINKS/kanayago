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
end
