# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicStringNodeTest < Minitest::Test
  def test_parse_dynamic_string_node
    result = Kanayago.parse('"S#{117}"')

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicStringNode, body)
    assert_equal('S', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~'PATTERN_TEST_CODE')
      "S#{117}"
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::DynamicStringNode
      assert_instance_of(Kanayago::DynamicStringNode, body)
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

    body in Kanayago::DynamicStringNode

    assert_instance_of(Kanayago::DynamicStringNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::DynamicStringNode

    assert_instance_of(Kanayago::DynamicStringNode, body)
  end
end
