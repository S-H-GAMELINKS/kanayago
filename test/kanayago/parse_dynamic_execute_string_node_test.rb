# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicExecuteStringNodeTest < Minitest::Test
  def test_parse_dynamic_execute_string_node
    # rubocop:disable Lint/InterpolationCheck
    result = Kanayago.parse('`echo #{name}`')
    # rubocop:enable Lint/InterpolationCheck

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicExecuteStringNode, body)
    assert_equal('echo ', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~'PATTERN_TEST_CODE')
      `echo #{name}`
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::DynamicExecuteStringNode
      assert_instance_of(Kanayago::DynamicExecuteStringNode, body)
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

    body in Kanayago::DynamicExecuteStringNode

    assert_instance_of(Kanayago::DynamicExecuteStringNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::DynamicExecuteStringNode

    assert_instance_of(Kanayago::DynamicExecuteStringNode, body)
  end
end
