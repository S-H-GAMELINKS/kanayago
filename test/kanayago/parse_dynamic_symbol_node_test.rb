# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicSymbolNodeTest < Minitest::Test
  def test_parse_dynamic_symbol_node
    result = Kanayago.parse(':"S#{117}"')

    body = result.body

    assert_instance_of(Kanayago::DynamicSymbolNode, body)
    assert_equal('S', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end

  def test_parse_empty_interpolation
    result = Kanayago.parse(':"#{\'\'}"')

    body = result.body

    assert_instance_of(Kanayago::DynamicSymbolNode, body)
    assert_equal('', body.string)
    assert_nil(body.next_nodes)
  end

  def test_parse_multiple_interpolations
    result = Kanayago.parse(':"#{a}_#{b}"')

    body = result.body

    assert_instance_of(Kanayago::DynamicSymbolNode, body)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)

    # First interpolation: #{a}
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val[0])

    # Static part: "_"
    assert_instance_of(Kanayago::StringNode, body.next_nodes.val[1])

    # Second interpolation: #{b}
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val[2])
  end

  def test_backward_compatibility_static_symbol
    result = Kanayago.parse(':static')

    body = result.body

    # Static symbols should remain SymbolNode, not DynamicSymbolNode
    assert_instance_of(Kanayago::SymbolNode, body)
  end
end
