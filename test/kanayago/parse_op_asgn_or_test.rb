# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpAsgnOrTest < Minitest::Test
  def test_parse_op_asgn_or
    result = Kanayago.parse('var ||= 42')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
    assert_instance_of(Kanayago::LocalVariableNode, body.head)
    assert_instance_of(Kanayago::LocalAssignmentNode, body.value)
  end

  def test_parse_op_asgn_or_global_variable
    result = Kanayago.parse('$gvar ||= []')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
    assert_instance_of(Kanayago::GlobalVariableNode, body.head)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      var ||= 42
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::OperatorAssignmentOrNode
      assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
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

    body in Kanayago::OperatorAssignmentOrNode

    assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::OperatorAssignmentOrNode

    assert_instance_of(Kanayago::OperatorAssignmentOrNode, body)
  end
end
