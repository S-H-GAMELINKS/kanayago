# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpAsgn2Test < Minitest::Test
  def test_parse_op_asgn2_plus
    result = Kanayago.parse('obj.attr += 10')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment2Node, body)
    assert_equal(:+, body.mid)
    assert_equal(:attr, body.vid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end

  def test_parse_op_asgn2_minus
    result = Kanayago.parse('obj.count -= 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment2Node, body)
    assert_equal(:-, body.mid)
    assert_equal(:count, body.vid)
  end

  def test_parse_op_asgn2_multiply
    result = Kanayago.parse('obj.value *= 2')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment2Node, body)
    assert_equal(:*, body.mid)
  end
end
