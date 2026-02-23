# frozen_string_literal: true

require_relative '../test_helper'

class ParseZeroListTest < Minitest::Test
  def test_parse_zero_list
    result = Kanayago.parse('[]')

    body = result.ast.body

    assert_instance_of(Kanayago::ZeroListNode, body)
    assert_equal(0, body.len)
    assert_empty(body.val)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      []
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ZeroListNode
      assert_instance_of(Kanayago::ZeroListNode, body)
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

    body in Kanayago::ZeroListNode

    assert_instance_of(Kanayago::ZeroListNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ZeroListNode

    assert_instance_of(Kanayago::ZeroListNode, body)
  end
end
