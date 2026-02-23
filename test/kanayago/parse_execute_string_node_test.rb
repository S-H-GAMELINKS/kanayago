# frozen_string_literal: true

require_relative '../test_helper'

class ParseExecuteStringNodeTest < Minitest::Test
  def test_parse_execute_string_node
    result = Kanayago.parse('`echo hello`')

    body = result.ast.body

    assert_instance_of(Kanayago::ExecuteStringNode, body)
    assert_equal('echo hello', body.ptr)
    assert_equal(10, body.len)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      `echo hello`
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ExecuteStringNode
      assert_instance_of(Kanayago::ExecuteStringNode, body)
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

    body in Kanayago::ExecuteStringNode

    assert_instance_of(Kanayago::ExecuteStringNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ExecuteStringNode

    assert_instance_of(Kanayago::ExecuteStringNode, body)
  end
end
