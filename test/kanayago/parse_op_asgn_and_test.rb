# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpAsgnAndTest < Minitest::Test
  def test_parse_op_asgn_and
    result = Kanayago.parse('var &&= 117')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::OperatorAssignmentAndNode, body)
    assert_instance_of(Kanayago::LocalVariableNode, body.head)
    assert_instance_of(Kanayago::LocalAssignmentNode, body.value)
  end

  def test_parse_op_asgn_and_instance_variable
    result = Kanayago.parse('@ivar &&= "value"')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::OperatorAssignmentAndNode, body)
    assert_instance_of(Kanayago::InstanceVariableNode, body.head)
  end
end
