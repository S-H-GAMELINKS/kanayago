# frozen_string_literal: true

require_relative '../test_helper'

class ParseIvarTest < Minitest::Test
  def test_parse_ivar
    result = Kanayago.parse('$kanayago')
    body = result.ast.body

    assert_instance_of(Kanayago::GlobalVariableNode, body)
    assert_equal(:$kanayago, body.vid)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      $kanayago
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::GlobalVariableNode
      assert_instance_of(Kanayago::GlobalVariableNode, body)
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

    body in Kanayago::GlobalVariableNode

    assert_instance_of(Kanayago::GlobalVariableNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::GlobalVariableNode

    assert_instance_of(Kanayago::GlobalVariableNode, body)
  end
end
