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
end
