# frozen_string_literal: true

require_relative '../test_helper'

class ParseUntilNodeTest < Minitest::Test
  def test_parse_while_node
    result = Kanayago.parse(<<~CODE)
      v = 115

      until (v == 117) do
        v += 1
      end
    CODE

    line = result.ast.body.last

    assert_instance_of(Kanayago::UntilNode, line)
    assert_equal(1, line.state)
    assert_instance_of(Kanayago::OperatorCallNode, line.cond.first)
    assert_instance_of(Kanayago::LocalAssignmentNode, line.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      v = 115

      until (v == 117) do
        v += 1
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::BlockNode
      assert_instance_of(Kanayago::BlockNode, body)
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

    body in Kanayago::BlockNode

    assert_instance_of(Kanayago::BlockNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::BlockNode

    assert_instance_of(Kanayago::BlockNode, body)
  end
end
