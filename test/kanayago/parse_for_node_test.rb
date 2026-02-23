# frozen_string_literal: true

require_relative '../test_helper'

class ParseForNodeTest < Minitest::Test
  def test_parse_for_node
    result = Kanayago.parse(<<~CODE)
      for i in [1, 2, 3] do
        p i
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ForNode, body)
    assert_instance_of(Kanayago::ListNode, body.iter)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      for i in [1, 2, 3] do
        p i
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ForNode
      assert_instance_of(Kanayago::ForNode, body)
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

    body in Kanayago::ForNode

    assert_instance_of(Kanayago::ForNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ForNode

    assert_instance_of(Kanayago::ForNode, body)
  end
end
