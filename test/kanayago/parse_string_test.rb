# frozen_string_literal: true

require_relative '../test_helper'

class ParseStringTest < Minitest::Test
  def test_parse_string
    result = Kanayago.parse('"Kanayago"')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::StringNode, body)
    assert_equal(body.ptr, 'Kanayago')
    assert_equal(body.len, 8)
    assert_equal(body.enc, Encoding::UTF_8)
    assert_equal(body.coderange, 'RB_PARSER_ENC_CODERANGE_7BIT')
  end

  def test_parse_string_plus_opcall
    result = Kanayago.parse('"Kanayago" + ".parse"')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::StringNode, body.recv)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::StringNode, arg)
  end

  def test_parse_string_times_opcall
    result = Kanayago.parse('"Kanayago" * 2')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::OperatorCallNode, body)
    assert_instance_of(Kanayago::StringNode, body.recv)
    assert_equal(:*, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.first

    assert_instance_of(Kanayago::IntegerNode, arg)
  end
end
