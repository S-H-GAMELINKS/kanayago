# frozen_string_literal: true

require_relative '../test_helper'

class ParseClassVariableNodeTest < Minitest::Test
  def test_parser_class_variable_node
    result = Kanayago.parse('@@var')

    body = result.ast.body

    assert_instance_of(Kanayago::ClassVariableNode, body)
    assert_equal(:@@var, body.vid)
  end
end
