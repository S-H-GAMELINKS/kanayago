# frozen_string_literal: true

require_relative '../test_helper'

class ParseRationalTest < Minitest::Test
  def test_parse_rational
    result = Kanayago.parse('117r')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::RationalNode, body)
    assert_equal(117r, body.val)
    refute(body.minus)
    assert_equal(10, body.base)
    assert_equal(0, body.seen_point)
  end

  def test_parse_rational_plus_opcall
    result = Kanayago.parse('117r + 117r')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::RationalNode, arg)
  end

  def test_parse_rational_minus_opcall
    result = Kanayago.parse('117r - 117r')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:-, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::RationalNode, arg)
  end

  def test_parse_rational_times_opcall
    result = Kanayago.parse('117r * 117r')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:*, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::RationalNode, arg)
  end

  def test_parse_rational_div_opcall
    result = Kanayago.parse('117r / 117r')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:/, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::RationalNode, arg)
  end

  def test_parse_rational_remainder_opcall
    result = Kanayago.parse('117r % 117r')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:%, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::RationalNode, arg)
  end

  def test_parse_rational_call
    result = Kanayago.parse('117r.to_i')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:to_i, body.mid)
    assert_nil(body.args)
  end

  def test_parse_rational_call_with_arg
    result = Kanayago.parse('117r.to_i(10)')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::RationalNode, body.recv)
    assert_equal(:to_i, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
  end
end
