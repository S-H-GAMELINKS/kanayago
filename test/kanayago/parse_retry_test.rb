# frozen_string_literal: true

require_relative '../test_helper'

class ParseRetryTest < Minitest::Test
  def test_parse_retry_in_rescue
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue
        retry
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)

    rescue_body = body.resq

    assert_instance_of(Kanayago::RescueBodyNode, rescue_body)
    assert_instance_of(Kanayago::RetryNode, rescue_body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      begin
        raise
      rescue
        retry
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::RescueNode
      assert_instance_of(Kanayago::RescueNode, body)
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

    body in Kanayago::RescueNode

    assert_instance_of(Kanayago::RescueNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::RescueNode

    assert_instance_of(Kanayago::RescueNode, body)
  end
end
