# frozen_string_literal: true

require_relative '../test_helper'

class ParseReturnNode < Minitest::Test
  def test_parse_single_statement_return_node
    result = Kanayago.parse(<<~CODE)
      return 117
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ReturnNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.statements)
  end

  def test_parse_multiple_statement_return_node
    result = Kanayago.parse(<<~CODE)
      return 117, 34
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ReturnNode, body)
    assert_instance_of(Kanayago::ListNode, body.statements)
    assert_instance_of(Kanayago::IntegerNode, body.statements.val.first)
    assert_instance_of(Kanayago::IntegerNode, body.statements.val.last)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      return 117
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ReturnNode
      assert_instance_of(Kanayago::ReturnNode, body)
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

    body in Kanayago::ReturnNode

    assert_instance_of(Kanayago::ReturnNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ReturnNode

    assert_instance_of(Kanayago::ReturnNode, body)
  end
end
