# frozen_string_literal: true

require_relative '../test_helper'

class ParseRescueTest < Minitest::Test
  def test_parse_rescue_basic
    result = Kanayago.parse(<<~CODE)
      begin
        1 / 0
      rescue
        puts "error"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    refute_nil(body.head)
    assert_instance_of(Kanayago::RescueBodyNode, body.resq)
  end

  def test_parse_rescue_with_exception_class
    result = Kanayago.parse(<<~CODE)
      begin
        raise StandardError
      rescue StandardError
        puts "caught"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    assert_instance_of(Kanayago::RescueBodyNode, body.resq)
  end

  def test_parse_rescue_with_else
    result = Kanayago.parse(<<~CODE)
      begin
        foo
      rescue
        bar
      else
        baz
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    refute_nil(body.else)
  end

  def test_parse_rescue_multiple_clauses
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue ArgumentError
        puts "arg error"
      rescue StandardError
        puts "std error"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    first_resbody = body.resq

    assert_instance_of(Kanayago::RescueBodyNode, first_resbody)
    assert_instance_of(Kanayago::RescueBodyNode, first_resbody.next)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      begin
        1 / 0
      rescue
        puts "error"
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::RescueNode
      assert_instance_of(Kanayago::RescueNode, body)
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

    body in Kanayago::RescueNode

    assert_instance_of(Kanayago::RescueNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::RescueNode

    assert_instance_of(Kanayago::RescueNode, body)
  end
end
