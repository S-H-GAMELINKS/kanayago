# frozen_string_literal: true

require_relative '../test_helper'

class ParseFcallTest < Minitest::Test
  def test_parse_fcall
    result = Kanayago.parse('p 117')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::FunctionCallNode, body)
    assert_equal(:p, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      p 117
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::FunctionCallNode
      assert_instance_of(Kanayago::FunctionCallNode, body)
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

    body in Kanayago::FunctionCallNode

    assert_instance_of(Kanayago::FunctionCallNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::FunctionCallNode

    assert_instance_of(Kanayago::FunctionCallNode, body)
  end
end
