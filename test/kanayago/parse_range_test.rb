# frozen_string_literal: true

require_relative '../test_helper'

class ParseRangeTest < Minitest::Test
  def test_parse_inclusive_range
    result = Kanayago.parse(<<~CODE)
      1..10
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::RangeNode, body)

    assert_instance_of(Kanayago::IntegerNode, body.beg)

    assert_instance_of(Kanayago::IntegerNode, body.end)
  end

  def test_parse_exclusive_range
    result = Kanayago.parse(<<~CODE)
      1...10
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::ExclusiveRangeNode, body)

    assert_instance_of(Kanayago::IntegerNode, body.beg)

    assert_instance_of(Kanayago::IntegerNode, body.end)
  end

  def test_parse_range_with_variables
    result = Kanayago.parse(<<~CODE)
      x..y
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RangeNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.beg)
    assert_instance_of(Kanayago::VariableCallNode, body.end)
  end

  def test_parse_exclusive_range_with_variables
    result = Kanayago.parse(<<~CODE)
      a...b
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ExclusiveRangeNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.beg)
    assert_instance_of(Kanayago::VariableCallNode, body.end)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      1..10
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::RangeNode
      assert_instance_of(Kanayago::RangeNode, body)
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

    body in Kanayago::RangeNode

    assert_instance_of(Kanayago::RangeNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::RangeNode

    assert_instance_of(Kanayago::RangeNode, body)
  end
end
