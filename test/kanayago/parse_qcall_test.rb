# frozen_string_literal: true

require_relative '../test_helper'

class ParseQcallTest < Minitest::Test
  def test_parse_qcall
    result = Kanayago.parse(<<~CODE)
      obj&.method_name
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::SafeCallNode, body)
    assert_equal(:method_name, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
  end

  def test_parse_qcall_with_args
    result = Kanayago.parse(<<~CODE)
      obj&.method_name(arg1, arg2)
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::SafeCallNode, body)
    assert_equal(:method_name, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::ListNode, body.args)
  end
end
