# frozen_string_literal: true

require_relative '../test_helper'

class ParseBackRefTest < Minitest::Test
  def test_parse_back_ref_dollar_ampersand
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /ll/
      p $&
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)

    arg = second_line.args.val.first

    assert_instance_of(Kanayago::BackRefNode, arg)
    assert_kind_of(Integer, arg.nth)
  end

  def test_parse_back_ref_in_expression
    result = Kanayago.parse(<<~CODE)
      if "test" =~ /es/
        puts $&
      end
    CODE

    body = result.body

    assert_instance_of(Kanayago::IfStatementNode, body)

    if_body = body.body

    assert_instance_of(Kanayago::FunctionCallNode, if_body)
  end

  def test_parse_back_ref_in_string_interpolation
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /ll/
      puts "matched: \#{$&}"
    CODE

    body = result.body

    assert_equal(2, body.size)

    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)
  end
end
