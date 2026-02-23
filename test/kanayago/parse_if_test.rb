# frozen_string_literal: true

require_relative '../test_helper'

class ParseIfTest < Minitest::Test
  def test_parse_if
    result = Kanayago.parse(<<~CODE)
      v = 117
      if v
        p v
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    arg = body.first

    assert_instance_of(Kanayago::LocalAssignmentNode, arg)

    arg = body.last

    assert_instance_of(Kanayago::IfStatementNode, arg)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      v = 117
      if v
        p v
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
