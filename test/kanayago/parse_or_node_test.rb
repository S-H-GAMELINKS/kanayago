# frozen_string_literal: true

require_relative '../test_helper'

class ParseOrNode < Minitest::Test
  def test_parse_or_node
    result = Kanayago.parse('1 || 2')

    body = result.ast.body

    assert_instance_of(Kanayago::OrNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.first)
    assert_instance_of(Kanayago::IntegerNode, body.second)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      1 || 2
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::OrNode
      assert_instance_of(Kanayago::OrNode, body)
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

    body in Kanayago::OrNode

    assert_instance_of(Kanayago::OrNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::OrNode

    assert_instance_of(Kanayago::OrNode, body)
  end
end
