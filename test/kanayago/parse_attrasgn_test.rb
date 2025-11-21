# frozen_string_literal: true

require_relative '../test_helper'

class ParseAttrasgnTest < Minitest::Test
  def test_parse_attrasgn_setter
    result = Kanayago.parse(<<~CODE)
      obj.attr = 117
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::AttributeAssignmentNode, body)
    assert_equal(:attr=, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::ListNode, body.args)
  end

  def test_parse_attrasgn_bracket
    result = Kanayago.parse(<<~CODE)
      obj[key] = value
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::AttributeAssignmentNode, body)
    assert_equal(:[]=, body.mid)
  end
end
