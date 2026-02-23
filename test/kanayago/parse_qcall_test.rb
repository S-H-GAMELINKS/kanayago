# frozen_string_literal: true

require_relative '../test_helper'

class ParseQcallTest < Minitest::Test
  def test_parse_qcall
    result = Kanayago.parse(<<~CODE)
      obj&.method_name
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::SafeCallNode, body)
    assert_equal(:method_name, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
  end

  def test_parse_qcall_with_args
    result = Kanayago.parse(<<~CODE)
      obj&.method_name(arg1, arg2)
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::SafeCallNode, body)
    assert_equal(:method_name, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::ListNode, body.args)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      obj&.method_name
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::SafeCallNode
      assert_instance_of(Kanayago::SafeCallNode, body)
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

    body in Kanayago::SafeCallNode

    assert_instance_of(Kanayago::SafeCallNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::SafeCallNode

    assert_instance_of(Kanayago::SafeCallNode, body)
  end
end
