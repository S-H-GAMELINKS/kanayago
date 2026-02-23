# frozen_string_literal: true

require_relative '../test_helper'

class ParseTrueNodeTest < Minitest::Test
  def test_parse_true_node
    result = Kanayago.parse('true')

    body = result.ast.body

    assert_instance_of(Kanayago::TrueNode, body)
    assert(body.val)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      true
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::TrueNode
      assert_instance_of(Kanayago::TrueNode, body)
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

    body in Kanayago::TrueNode

    assert_instance_of(Kanayago::TrueNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::TrueNode

    assert_instance_of(Kanayago::TrueNode, body)
  end
end
