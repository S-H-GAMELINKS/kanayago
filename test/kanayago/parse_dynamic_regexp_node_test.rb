# frozen_string_literal: true

require_relative '../test_helper'

class ParseDynamicRegexpNodeTest < Minitest::Test
  def test_parse_dynamic_regexp_node
    # rubocop:disable Lint/InterpolationCheck
    result = Kanayago.parse('/hello #{name}/')
    # rubocop:enable Lint/InterpolationCheck

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicRegexpNode, body)
    assert_equal('hello ', body.string)
    assert_instance_of(Kanayago::ListNode, body.next_nodes)
    assert_instance_of(Kanayago::EmbeddedExpressionStringNode, body.next_nodes.val.first)
  end

  def test_parse_dynamic_regexp_node_with_options
    # rubocop:disable Lint/InterpolationCheck
    result = Kanayago.parse('/hello #{name}/im')
    # rubocop:enable Lint/InterpolationCheck

    body = result.ast.body

    assert_instance_of(Kanayago::DynamicRegexpNode, body)
    assert_equal('hello ', body.string)
    assert_equal(5, body.options)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~'PATTERN_TEST_CODE')
      /hello #{name}/
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::DynamicRegexpNode
      assert_instance_of(Kanayago::DynamicRegexpNode, body)
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

    body in Kanayago::DynamicRegexpNode

    assert_instance_of(Kanayago::DynamicRegexpNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::DynamicRegexpNode

    assert_instance_of(Kanayago::DynamicRegexpNode, body)
  end
end
