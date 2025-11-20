# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpAsgnOrTest < Minitest::Test
  def test_parse_op_asgn_or
    result = Kanayago.parse('var ||= 42')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
    assert_instance_of(Kanayago::LocalVariableNode, body.head)
    assert_instance_of(Kanayago::LocalAssignmentNode, body.value)
  end

  def test_parse_op_asgn_or_global_variable
    result = Kanayago.parse('$gvar ||= []')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
    assert_instance_of(Kanayago::GlobalVariableNode, body.head)
  end
end
