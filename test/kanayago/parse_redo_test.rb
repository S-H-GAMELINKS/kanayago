# frozen_string_literal: true

require_relative '../test_helper'

class ParseRedoTest < Minitest::Test
  def test_parse_redo_basic
    result = Kanayago.parse('loop { redo }')
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    iter_body = body.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)
    assert_instance_of(Kanayago::RedoNode, iter_body.body)
  end

  def test_parse_redo_conditional
    result = Kanayago.parse('loop { redo if true }')
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    iter_body = body.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)
    assert_instance_of(Kanayago::IfStatementNode, iter_body.body)
    assert_instance_of(Kanayago::RedoNode, iter_body.body.body)
  end

  def test_parse_redo_in_iterator
    result = Kanayago.parse('3.times { redo }')
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    iter_body = body.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)
    assert_instance_of(Kanayago::RedoNode, iter_body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      loop { redo }
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::IterNode
      assert_instance_of(Kanayago::IterNode, body)
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

    body in Kanayago::IterNode

    assert_instance_of(Kanayago::IterNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::IterNode

    assert_instance_of(Kanayago::IterNode, body)
  end
end
