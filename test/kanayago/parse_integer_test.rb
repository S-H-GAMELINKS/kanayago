# frozen_string_literal: true

require_relative '../test_helper'

class ParseIntegerTest < Minitest::Test
  def test_parse_integer
    result = Kanayago.parse('1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::IntegerNode, body)
    assert_equal(1, body.val)
    refute(body.minus)
    assert_equal(10, body.base)
  end

  def test_parse_integer_plus_opcall
    result = Kanayago.parse('1 + 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(1, arg.val)
  end

  def test_parse_integer_minus_opcall
    result = Kanayago.parse('1 - 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:-, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(1, arg.val)
  end

  def test_parse_integer_times_opcall
    result = Kanayago.parse('1 * 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:*, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(1, arg.val)
  end

  def test_parse_integer_div_opcall
    result = Kanayago.parse('1 / 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:/, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(1, arg.val)
  end

  def test_parse_integer_remainder_opcall
    result = Kanayago.parse('1 % 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:%, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(1, arg.val)
  end

  def test_parse_integer_call
    result = Kanayago.parse('1.to_i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:to_i, body.mid)
    assert_nil(body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)
  end

  def test_parse_integer_call_with_arg
    result = Kanayago.parse('1.to_i(10)')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.recv)
    assert_equal(:to_i, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    recv = body.recv

    assert_instance_of(Kanayago::IntegerNode, recv)
    assert_equal(1, recv.val)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
    assert_equal(10, arg.val)
  end

  def test_case_in_matched
    result = Kanayago.parse('117')

    body = result.ast.body

    case body
    in Kanayago::IntegerNode(val:, minus:, base:)
      assert_equal(117, val)
      refute(minus)
      assert_equal(10, base)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('117')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::IntegerNode(val:, minus: true, base:)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('117')

    body = result.ast.body

    body in Kanayago::IntegerNode(val:, minus:, base:)

    assert_equal(117, val)
    refute(minus)
    assert_equal(10, base)
  end

  def test_right_assignment
    result = Kanayago.parse('117')

    body = result.ast.body

    body => Kanayago::IntegerNode(val:, minus:, base:)

    assert_equal(117, val)
    refute(minus)
    assert_equal(10, base)
  end
end
