# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicExecuteStringNodeTest < Minitest::Test
  def test_parse_dynamic_execute_string_node
    # rubocop:disable Lint/InterpolationCheck
    result = Kanayago.parse('`echo #{name}`')
    # rubocop:enable Lint/InterpolationCheck

    body = result.body

    assert_instance_of(Kanayago::DynamicExecuteStringNode, body)
    assert_equal('echo ', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end
end
