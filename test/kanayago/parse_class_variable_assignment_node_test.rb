# frozen_string_literal: true

require_relative '../test_helper'

class ParseClassVariableAssignmentNodeTest < Minitest::Test
  def test_parse_class_variable_assignment_node
    result = Kanayago.parse('@@var = 117')

    body = result.ast.body

    assert_instance_of(Kanayago::ClassVariableAssignmentNode, body)
    assert_equal(:@@var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      @@var = 117
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ClassVariableAssignmentNode
      assert_instance_of(Kanayago::ClassVariableAssignmentNode, body)
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

    body in Kanayago::ClassVariableAssignmentNode

    assert_instance_of(Kanayago::ClassVariableAssignmentNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ClassVariableAssignmentNode

    assert_instance_of(Kanayago::ClassVariableAssignmentNode, body)
  end
end
