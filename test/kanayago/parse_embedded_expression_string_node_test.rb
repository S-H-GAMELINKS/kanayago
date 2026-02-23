# frozen_string_literal: true

require_relative '../test_helper'

class ParseEmbeddedExpressionStringNodeTest < Minitest::Test
  def test_parse_embedded_expression_string_node_test
    result = Kanayago.parse('"S#{117}"')

    next_head_node = result.ast.body.next_nodes.val.first

    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, next_head_node)
    assert_instance_of(Kanayago::IntegerNode, next_head_node.body)
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
