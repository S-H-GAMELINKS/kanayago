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

  # rubocop:disable Lint/InterpolationCheck
  def test_parse_empty_interpolation
    result = Kanayago.parse(':"#{""}"')

    body = result.body

    assert_instance_of(Kanayago::DynamicSymbolNode, body)
    assert_equal('', body.string)
    assert_nil(body.next_nodes)
  end
  # rubocop:enable Lint/InterpolationCheck

  # rubocop:disable Lint/InterpolationCheck
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
  # rubocop:enable Lint/InterpolationCheck

  def test_backward_compatibility_static_symbol
    result = Kanayago.parse(':static')

    body = result.body

    # Static symbols should remain SymbolNode, not DynamicSymbolNode
    assert_instance_of(Kanayago::SymbolNode, body)
  end

  def test_dynamic_symbol_in_hash_with_to_h_block
    code = <<~'RUBY'
      SIZES = [16, 32, 48]
      STYLES = SIZES.to_h do |size|
        [:"#{size}", { format: 'png', geometry: "#{size}x#{size}#" }]
      end
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result)
    refute_nil(result.body)
  end

  def test_complex_nested_hash_with_dynamic_symbols
    code = <<~'RUBY'
      SIZES = [57, 60, 72]
      CONFIG = {
        icons: SIZES.to_h do |size|
          [:"#{size}", {
            format: 'png',
            geometry: "#{size}x#{size}#",
            options: { quality: 90 }
          }]
        end.freeze
      }
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result)
    refute_nil(result.body)
  end
end
