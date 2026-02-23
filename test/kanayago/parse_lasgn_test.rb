# frozen_string_literal: true

require_relative '../test_helper'

class ParseLasgnTest < Minitest::Test
  def test_parse_lasgn
    result = Kanayago.parse('var = 117')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::LocalAssignmentNode, body)
    assert_equal(:var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)

    value = body.value

    assert_equal(117, value.val)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      var = 117
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::LocalAssignmentNode
      assert_instance_of(Kanayago::LocalAssignmentNode, body)
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

    body in Kanayago::LocalAssignmentNode

    assert_instance_of(Kanayago::LocalAssignmentNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::LocalAssignmentNode

    assert_instance_of(Kanayago::LocalAssignmentNode, body)
  end
end
