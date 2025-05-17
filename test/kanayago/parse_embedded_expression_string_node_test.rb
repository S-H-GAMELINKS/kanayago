# frozen_string_literal: true

require_relative '../test_helper'

class ParseEmbeddedExpressionStringNodeTest < Minitest::Test
  def test_parse_embedded_expression_string_node_test
    result = Kanayago.parse('"S#{117}"')

    next_head_node = result.body.next_nodes.val.first

    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, next_head_node)
    assert_instance_of(Kanayago::IntegerNode, next_head_node.body)
  end
end
