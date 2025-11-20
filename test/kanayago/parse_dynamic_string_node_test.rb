# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicStringNodeTest < Minitest::Test
  def test_parse_dynamic_string_node
    result = Kanayago.parse('"S#{117}"')

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicStringNode, body)
    assert_equal('S', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end
end
