# frozen_string_literal: true

require_relative '../test_helper'

class ParseRegexpNodeTest < Minitest::Test
  def test_parse_regexp_node
    result = Kanayago.parse('/hello/')

    body = result.ast.body

    assert_instance_of(Kanayago::RegexpNode, body)
    assert_equal('hello', body.ptr)
    assert_equal(5, body.len)
  end

  def test_parse_regexp_node_with_options
    result = Kanayago.parse('/hello/i')

    body = result.ast.body

    assert_instance_of(Kanayago::RegexpNode, body)
    assert_equal('hello', body.ptr)
    assert_equal(5, body.len)
    assert_equal(1, body.options)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      /hello/
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::RegexpNode
      assert_instance_of(Kanayago::RegexpNode, body)
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

    body in Kanayago::RegexpNode

    assert_instance_of(Kanayago::RegexpNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::RegexpNode

    assert_instance_of(Kanayago::RegexpNode, body)
  end
end
