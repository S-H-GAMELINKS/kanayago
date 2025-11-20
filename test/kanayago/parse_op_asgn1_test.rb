# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpAsgn1Test < Minitest::Test
  def test_parse_op_asgn1_plus
    result = Kanayago.parse('ary[0] += 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::ListNode, body.index)
    assert_instance_of(Kanayago::IntegerNode, body.rvalue)
  end

  def test_parse_op_asgn1_or
    result = Kanayago.parse('hash[:key] ||= "default"')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
  end

  def test_parse_op_asgn1_and
    result = Kanayago.parse('ary[1] &&= value')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
  end
end
