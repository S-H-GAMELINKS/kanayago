# frozen_string_literal: true

require_relative '../test_helper'

class ParseIntegerTest < Minitest::Test
  def test_parse_integer
    result = Kanayago.parse('1')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::IntegerNode, body)
    assert_equal(body.val, 1)
    assert_equal(body.minus, false)
    assert_equal(body.base, 10)
  end

  def test_parse_integer_plus_opcall
    result = Kanayago.parse('1 + 1')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :+)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(arg.val, 1)
  end

  def test_parse_integer_minus_opcall
    result = Kanayago.parse('1 - 1')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :-)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(arg.val, 1)
  end

  def test_parse_integer_times_opcall
    result = Kanayago.parse('1 * 1')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :*)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(arg.val, 1)
  end

  def test_parse_integer_div_opcall
    result = Kanayago.parse('1 / 1')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :/)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(arg.val, 1)
  end

  def test_parse_integer_remainder_opcall
    result = Kanayago.parse('1 % 1')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :%)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(arg.val, 1)
  end

  def test_parse_integer_call
    result = Kanayago.parse('1.to_i')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :to_i)
    assert_nil(body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)
  end

  def test_parse_integer_call_with_arg
    result = Kanayago.parse('1.to_i(10)')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(body.mid, :to_i)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(recv.val, 1)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(arg.val, 10)
  end
end
