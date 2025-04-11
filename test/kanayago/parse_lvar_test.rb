# frozen_string_literal: true

require_relative '../test_helper'

class ParseLvarTest < Minitest::Test
  def test_parse_lvar
    result = Kanayago.parse(<<~CODE)
      v = 117
      p v
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    line = body.first

    assert_instance_of(Kanayago::LeftAssignNode, line)
    assert_equal(:v, line.id)
    assert_instance_of(Kanayago::IntegerNode, line.value)

    line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, line)
    assert_equal(:p, line.mid)
    assert_instance_of(Kanayago::ListNode, line.args)

    arg = line.args.first

    assert_instance_of(Kanayago::LocalVariableNode, arg)
    assert_equal(:v, arg.vid)
  end
end
