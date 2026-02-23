# frozen_string_literal: true

require_relative '../test_helper'

class ParseFalseNodeTest < Minitest::Test
  def test_parse_false_node
    result = Kanayago.parse('false')

    body = result.ast.body

    assert_instance_of(Kanayago::FalseNode, body)
    refute(body.val)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      false
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::FalseNode
      assert_instance_of(Kanayago::FalseNode, body)
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

    body in Kanayago::FalseNode

    assert_instance_of(Kanayago::FalseNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::FalseNode

    assert_instance_of(Kanayago::FalseNode, body)
  end
end
