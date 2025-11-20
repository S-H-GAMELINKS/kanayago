# frozen_string_literal: true

require_relative '../test_helper'

class ParseGlobalAssignmentNodeTest < Minitest::Test
  def test_parse_global_assignment_node
    result = Kanayago.parse('$var = 117')

    body = result.ast.body

    assert_instance_of(Kanayago::GlobalAssignmentNode, body)
    assert_equal(:$var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end
end
