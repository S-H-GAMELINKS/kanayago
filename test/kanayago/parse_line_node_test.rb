# frozen_string_literal: true

require_relative '../test_helper'

class ParseLineNodeTest < Minitest::Test
  def test_parse_line_node
    result = Kanayago.parse('__LINE__')

    body = result.ast.body

    assert_instance_of(Kanayago::LineNode, body)
    assert_equal(0, body.lineno)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      __LINE__
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::LineNode
      assert_instance_of(Kanayago::LineNode, body)
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

    body in Kanayago::LineNode

    assert_instance_of(Kanayago::LineNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::LineNode

    assert_instance_of(Kanayago::LineNode, body)
  end
end
