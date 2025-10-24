# frozen_string_literal: true

require_relative '../test_helper'

class ParseYieldTest < Minitest::Test
  def test_parse_yield_no_args
    result = Kanayago.parse('def foo; yield; end')

    assert_instance_of(Kanayago::ScopeNode, result)
    definition_node = result.body

    assert_instance_of(Kanayago::DefinitionNode, definition_node)
    scope_node = definition_node.defn

    assert_instance_of(Kanayago::ScopeNode, scope_node)
    yield_node = scope_node.body

    assert_instance_of(Kanayago::YieldNode, yield_node)
    assert_nil(yield_node.head)
  end

  def test_parse_yield_single_arg
    result = Kanayago.parse('def foo; yield 42; end')

    assert_instance_of(Kanayago::ScopeNode, result)
    definition_node = result.body
    scope_node = definition_node.defn
    yield_node = scope_node.body

    assert_instance_of(Kanayago::YieldNode, yield_node)
    assert_instance_of(Kanayago::ListNode, yield_node.head)
    assert_equal(1, yield_node.head.len)
  end

  def test_parse_yield_multiple_args
    result = Kanayago.parse('def foo; yield 1, 2, 3; end')

    assert_instance_of(Kanayago::ScopeNode, result)
    definition_node = result.body
    scope_node = definition_node.defn
    yield_node = scope_node.body

    assert_instance_of(Kanayago::YieldNode, yield_node)
    assert_instance_of(Kanayago::ListNode, yield_node.head)
  end
end
