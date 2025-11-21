# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicRegexpNodeTest < Minitest::Test
  def test_parse_dynamic_regexp_node
    # rubocop:disable Lint/InterpolationCheck
    result = Kanayago.parse('/hello #{name}/')
    # rubocop:enable Lint/InterpolationCheck

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicRegexpNode, body)
    assert_equal('hello ', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end

  def test_parse_dynamic_regexp_node_with_options
    # rubocop:disable Lint/InterpolationCheck
    result = Kanayago.parse('/hello #{name}/im')
    # rubocop:enable Lint/InterpolationCheck

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicRegexpNode, body)
    assert_equal('hello ', body.string)
    assert_equal(5, body.options)
  end
end
