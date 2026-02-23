# frozen_string_literal: true

require_relative '../test_helper'

class ParseNthRefTest < Minitest::Test
  def test_parse_nth_ref_dollar_one
    result = Kanayago.parse(<<~CODE)
      "hello" =~ /(.)(.)/
      p $1
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

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

    body = result.ast.body
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

    body = result.ast.body
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

    body = result.ast.body

    assert_equal(2, body.size)

    second_line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, second_line)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      "hello" =~ /(.)(.)/
      p $1
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::BlockNode
      assert_instance_of(Kanayago::BlockNode, body)
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

    body in Kanayago::BlockNode

    assert_instance_of(Kanayago::BlockNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::BlockNode

    assert_instance_of(Kanayago::BlockNode, body)
  end
end
