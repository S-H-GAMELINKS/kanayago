# frozen_string_literal: true

require_relative '../test_helper'

class ParseClassVariableAssignmentNodeTest < Minitest::Test
  def test_parse_class_variable_assignment_node
    result = Kanayago.parse('@@var = 117')

    body = result.ast.body

    assert_instance_of(Kanayago::ClassVariableAssignmentNode, body)
    assert_equal(:@@var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end
end
