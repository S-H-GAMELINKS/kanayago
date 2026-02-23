# frozen_string_literal: true

require_relative '../test_helper'

class ParseOnceTest < Minitest::Test
  def test_parse_begin_block
    result = Kanayago.parse('BEGIN { puts "hello" }')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    refute_nil(result.ast.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      BEGIN { puts "hello" }
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
