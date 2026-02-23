# frozen_string_literal: true

require_relative '../test_helper'

class ParseImaginaryTest < Minitest::Test
  def test_parse_imaginary
    result = Kanayago.parse('117i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::ImaginaryNode, body)
    assert_equal(0 + 117i, body.val)
    assert_equal(10, body.base)
    refute(body.minus)
    assert_equal(0, body.seen_point)
    assert_equal('integer_literal', body.type)
  end

  def test_parse_imaginary_plus_opcall
    result = Kanayago.parse('117i + 117i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::ImaginaryNode, body.recv)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::ImaginaryNode, arg)
  end

  def test_parse_imaginary_minus_opcall
    result = Kanayago.parse('117i - 117i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::ImaginaryNode, body.recv)
    assert_equal(:-, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::ImaginaryNode, arg)
  end

  def test_parse_imaginary_times_opcall
    result = Kanayago.parse('117i * 117i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::ImaginaryNode, body.recv)
    assert_equal(:*, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::ImaginaryNode, arg)
  end

  def test_parse_imaginary_div_opcall
    result = Kanayago.parse('117i / 117i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::ImaginaryNode, body.recv)
    assert_equal(:/, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::ImaginaryNode, arg)
  end

  def test_parse_imaginary_remainder_opcall
    result = Kanayago.parse('117i % 117i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::ImaginaryNode, body.recv)
    assert_equal(:%, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::ImaginaryNode, arg)
  end

  def test_parse_imaginary_call
    result = Kanayago.parse('117i.to_i')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::CallNode, body)
    assert_instance_of(Kanayago::ImaginaryNode, body.recv)
    assert_equal(:to_i, body.mid)
    assert_nil(body.args)
  end

  def test_parse_imaginary_call_with_arg; end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      117i
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ImaginaryNode
      assert_instance_of(Kanayago::ImaginaryNode, body)
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

    body in Kanayago::ImaginaryNode

    assert_instance_of(Kanayago::ImaginaryNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ImaginaryNode

    assert_instance_of(Kanayago::ImaginaryNode, body)
  end
end
