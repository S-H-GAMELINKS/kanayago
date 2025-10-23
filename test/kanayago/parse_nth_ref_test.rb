# frozen_string_literal: true

require_relative '../test_helper'

class ParseNthRefTest < Minitest::Test
  def test_parse_nth_ref_dollar_one
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /(.)(.)/
      p $1
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)

    arg = second_line.args.val.first

    assert_instance_of(Kanayago::NthRefNode, arg)
    assert_equal(1, arg.nth)
  end

  def test_parse_nth_ref_dollar_two
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /(.)(.)(.)/
      p $2
    CODE

    body = result.body
    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)

    arg = second_line.args.val.first

    assert_instance_of(Kanayago::NthRefNode, arg)
    assert_equal(2, arg.nth)
  end

  def test_parse_multiple_nth_refs
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /(.)(.)(.)/
      p $1, $2, $3
    CODE

    body = result.body
    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)
    args = second_line.args.val

    assert_instance_of(Kanayago::NthRefNode, args[0])
    assert_equal(1, args[0].nth)

    assert_instance_of(Kanayago::NthRefNode, args[1])
    assert_equal(2, args[1].nth)

    assert_instance_of(Kanayago::NthRefNode, args[2])
    assert_equal(3, args[2].nth)
  end

  def test_parse_nth_ref_in_string_interpolation
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /(.)(.)/
      puts "\#{$1}"
    CODE

    body = result.body

    assert_equal(2, body.size)

    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)
  end
end
