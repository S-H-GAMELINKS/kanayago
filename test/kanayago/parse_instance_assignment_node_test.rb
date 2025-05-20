# frozen_string_literal: true

require_relative '../test_helper'

class ParseInstanceAssignmentNodeTest < Minitest::Test
  def test_parse_instance_assignment_node
    result = Kanayago.parse('@var = 117')

    body = result.body

    assert_instance_of(Kanayago::InstanceAssignmentNode, body)
    assert_equal(:@var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end
end
