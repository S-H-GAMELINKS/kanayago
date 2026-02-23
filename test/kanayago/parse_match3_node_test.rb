# frozen_string_literal: true

require_relative '../test_helper'

class ParseMatch3NodeTest < Minitest::Test
  def test_parse_match3_node
    result = Kanayago.parse('"bar" =~ /foo#{1}/')

    body = result.ast.body

    assert_instance_of(Kanayago::Match3Node, body)
    assert_instance_of(Kanayago::DynamicRegexpNode, body.recv)
    assert_instance_of(Kanayago::StringNode, body.value)
    assert_equal('bar', body.value.ptr)
  end

  def test_parse_match3_node_with_variable
    result = Kanayago.parse('x = 1; "test" =~ /pattern#{x}/')

    block = result.ast.body
    match3_node = block[1]

    assert_instance_of(Kanayago::Match3Node, match3_node)
    assert_instance_of(Kanayago::DynamicRegexpNode, match3_node.recv)
    assert_instance_of(Kanayago::StringNode, match3_node.value)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~'PATTERN_TEST_CODE')
      "bar" =~ /foo#{1}/
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::Match3Node
      assert_instance_of(Kanayago::Match3Node, body)
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

    body in Kanayago::Match3Node

    assert_instance_of(Kanayago::Match3Node, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::Match3Node

    assert_instance_of(Kanayago::Match3Node, body)
  end
end
