# frozen_string_literal: true

require_relative '../test_helper'

class ParseCaseTest < Minitest::Test
  def test_parse_case_when
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      when 2
        puts "two"
      else
        puts "other"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::CaseNode, body)

    assert_instance_of(Kanayago::VariableCallNode, body.head)

    assert_instance_of(Kanayago::WhenNode, body.body)
  end

  def test_parse_case_single_when
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::CaseNode, body)

    assert_instance_of(Kanayago::VariableCallNode, body.head)
    assert_instance_of(Kanayago::WhenNode, body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      case x
      when 1
        puts "one"
      when 2
        puts "two"
      else
        puts "other"
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::CaseNode
      assert_instance_of(Kanayago::CaseNode, body)
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

    body in Kanayago::CaseNode

    assert_instance_of(Kanayago::CaseNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::CaseNode

    assert_instance_of(Kanayago::CaseNode, body)
  end
end
