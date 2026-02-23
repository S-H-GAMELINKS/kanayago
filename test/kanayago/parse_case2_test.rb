# frozen_string_literal: true

require_relative '../test_helper'

class ParseCase2Test < Minitest::Test
  def test_parse_case_without_condition
    result = Kanayago.parse(<<~CODE)
      case
      when true
        puts "yes"
      when false
        puts "no"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::Case2Node, body)

    assert_instance_of(Kanayago::WhenNode, body.body)
  end

  def test_parse_case_without_condition_single_when
    result = Kanayago.parse(<<~CODE)
      case
      when 1 == 1
        puts "match"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::Case2Node, body)

    assert_instance_of(Kanayago::WhenNode, body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      case
      when true
        puts "yes"
      when false
        puts "no"
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::Case2Node
      assert_instance_of(Kanayago::Case2Node, body)
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

    body in Kanayago::Case2Node

    assert_instance_of(Kanayago::Case2Node, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::Case2Node

    assert_instance_of(Kanayago::Case2Node, body)
  end
end
