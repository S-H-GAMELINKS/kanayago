# frozen_string_literal: true

require_relative '../test_helper'

class ParseConstTest < Minitest::Test
  def test_parse_const
    result = Kanayago.parse('Class')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::ConstantNode, body)
    assert_equal(:Class, body.vid)
  end

  def test_parse_const_ref
    result = Kanayago.parse(<<~CODE)
      S = 117
      p S
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    line = body.first

    assert_instance_of(Kanayago::ConstantDeclarationNode, line)
    assert_equal(:S, line.vid)
    assert_nil(line.else)
    assert_instance_of(Kanayago::IntegerNode, line.value)

    line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, line)
    assert_equal(:p, line.mid)
    assert_instance_of(Kanayago::ListNode, line.args)

    arg = line.args.val.first

    assert_instance_of(Kanayago::ConstantNode, arg)
    assert_equal(:S, arg.vid)
  end
end
