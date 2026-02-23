# frozen_string_literal: true

require_relative '../test_helper'

class ParseEnsureTest < Minitest::Test
  def test_parse_ensure_basic
    result = Kanayago.parse(<<~CODE)
      begin
        foo
      ensure
        bar
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::EnsureNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.head)
    assert_instance_of(Kanayago::VariableCallNode, body.ensr)
  end

  def test_parse_ensure_with_rescue
    result = Kanayago.parse(<<~CODE)
      begin
        foo
      rescue
        bar
      ensure
        baz
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::EnsureNode, body)
    assert_instance_of(Kanayago::RescueNode, body.head)
    assert_instance_of(Kanayago::VariableCallNode, body.ensr)
  end

  def test_parse_ensure_with_multiple_statements
    result = Kanayago.parse(<<~CODE)
      begin
        a = 1
        b = 2
      ensure
        c = 3
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::EnsureNode, body)
    refute_nil(body.head)
    refute_nil(body.ensr)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      begin
        foo
      ensure
        bar
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::EnsureNode
      assert_instance_of(Kanayago::EnsureNode, body)
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

    body in Kanayago::EnsureNode

    assert_instance_of(Kanayago::EnsureNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::EnsureNode

    assert_instance_of(Kanayago::EnsureNode, body)
  end
end
