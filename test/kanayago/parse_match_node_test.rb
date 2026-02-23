# frozen_string_literal: true

require_relative '../test_helper'

class ParseMatchNodeTest < Minitest::Test
  def test_parse_match_node
    result = Kanayago.parse('if /hello/ then end')

    scope = result.ast
    if_node = scope.body
    cond = if_node.cond

    assert_instance_of(Kanayago::MatchNode, cond)
    assert_equal('hello', cond.ptr)
    assert_equal(5, cond.len)
  end

  def test_parse_match_node_with_options
    result = Kanayago.parse('if /hello/i then end')

    scope = result.ast
    if_node = scope.body
    cond = if_node.cond

    assert_instance_of(Kanayago::MatchNode, cond)
    assert_equal('hello', cond.ptr)
    assert_equal(1, cond.options)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      if /hello/ then end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::IfStatementNode
      assert_instance_of(Kanayago::IfStatementNode, body)
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

    body in Kanayago::IfStatementNode

    assert_instance_of(Kanayago::IfStatementNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::IfStatementNode

    assert_instance_of(Kanayago::IfStatementNode, body)
  end
end
