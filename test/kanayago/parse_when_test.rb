# frozen_string_literal: true

require_relative '../test_helper'

class ParseWhenTest < Minitest::Test
  def test_parse_when_single_condition
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      end
    CODE

    body = result.ast.body.body # CaseNode -> WhenNode

    assert_instance_of(Kanayago::WhenNode, body)

    assert_instance_of(Kanayago::ListNode, body.head)

    refute_nil(body.body)

    assert_nil(body.next)
  end

  def test_parse_when_multiple_conditions
    result = Kanayago.parse(<<~CODE)
      case x
      when 1, 2, 3
        puts "small"
      end
    CODE

    body = result.ast.body.body

    assert_instance_of(Kanayago::WhenNode, body)
    assert_instance_of(Kanayago::ListNode, body.head)
  end

  def test_parse_when_chain
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      when 2
        puts "two"
      end
    CODE

    first_when = result.ast.body.body

    assert_instance_of(Kanayago::WhenNode, first_when)

    second_when = first_when.next

    assert_instance_of(Kanayago::WhenNode, second_when)

    assert_nil(second_when.next)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      case x
      when 1
        puts "one"
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
