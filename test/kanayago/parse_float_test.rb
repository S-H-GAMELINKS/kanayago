# frozen_string_literal: true

require_relative '../test_helper'

class ParseFloatTest < Minitest::Test
  def test_parse_float
    result = Kanayago.parse('1.17')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::FloatNode, body)
    assert_in_delta(1.17, body.val)
    refute(body.minus)
  end

  def test_parse_float_plus_opcall
    result = Kanayago.parse('1.17 + 1.17')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::FloatNode, arg)
  end

  def test_parse_float_minus_opcall
    result = Kanayago.parse('1.17 - 1.17')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:-, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::FloatNode, arg)
  end

  def test_parse_float_times_opcall
    result = Kanayago.parse('1.17 * 1.17')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:*, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::FloatNode, arg)
  end

  def test_parse_float_div_opcall
    result = Kanayago.parse('1.17 / 1.17')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:/, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::FloatNode, arg)
  end

  def test_parse_float_remainder_opcall
    result = Kanayago.parse('1.17 % 1.17')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:%, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::FloatNode, arg)
  end

  def test_parse_float_call
    result = Kanayago.parse('1.17.to_i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:to_i, body.mid)
    assert_nil(body.args)
  end

  def test_parse_float_call_with_arg
    result = Kanayago.parse('1.17.to_i(10)')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::FloatNode, body.recv)
    assert_equal(:to_i, body.mid)

    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      1.17
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::FloatNode
      assert_instance_of(Kanayago::FloatNode, body)
    end
  end

  def test_case_in_unmatched
    body = pattern_match_target_body

    assert_raises(NoMatchingPatternError) do
      case body.class.name
      in '__kanayago_unmatched_pattern__'
        # Nothing to do
      end
    end
  end

  def test_single_in
    body = pattern_match_target_body

    body in Kanayago::FloatNode

    assert_instance_of(Kanayago::FloatNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::FloatNode

    assert_instance_of(Kanayago::FloatNode, body)
  end
end
