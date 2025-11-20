# frozen_string_literal: true

require_relative '../test_helper'

class ParseStringTest < Minitest::Test
  def test_parse_string
    result = Kanayago.parse('"Kanayago"')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::StringNode, body)
    assert_equal('Kanayago', body.ptr)
    assert_equal(8, body.len)
    assert_equal(body.enc, Encoding::UTF_8)
    assert_equal('RB_PARSER_ENC_CODERANGE_7BIT', body.coderange)
  end

  def test_parse_string_plus_opcall
    result = Kanayago.parse('"Kanayago" + ".parse"')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::StringNode, body.recv)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::StringNode, arg)
  end

  def test_parse_string_times_opcall
    result = Kanayago.parse('"Kanayago" * 2')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::StringNode, body.recv)
    assert_equal(:*, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
  end
end
