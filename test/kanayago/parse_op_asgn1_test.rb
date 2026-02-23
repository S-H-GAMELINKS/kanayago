# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpAsgn1Test < Minitest::Test
  def test_parse_op_asgn1_plus
    result = Kanayago.parse('ary[0] += 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
    assert_equal(:+, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::ListNode, body.index)
    assert_instance_of(Kanayago::IntegerNode, body.rvalue)
  end

  def test_parse_op_asgn1_or
    result = Kanayago.parse('hash[:key] ||= "default"')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
  end

  def test_parse_op_asgn1_and
    result = Kanayago.parse('ary[1] &&= value')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      ary[0] += 1
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::OperatorAssignment1Node
      assert_instance_of(Kanayago::OperatorAssignment1Node, body)
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

    body in Kanayago::OperatorAssignment1Node

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::OperatorAssignment1Node

    assert_instance_of(Kanayago::OperatorAssignment1Node, body)
  end
end
