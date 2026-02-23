# frozen_string_literal: true

require_relative '../test_helper'

class ParseUndefNodeTest < Minitest::Test
  def test_parse_undef_node
    result = Kanayago.parse('undef :send')

    body = result.ast.body

    assert_instance_of(Kanayago::UndefNode, body)
    assert_instance_of(Array, body.undefs)
    assert_equal(1, body.undefs.size)
    assert_instance_of(Kanayago::SymbolNode, body.undefs.first)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      undef :send
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::UndefNode
      assert_instance_of(Kanayago::UndefNode, body)
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

    body in Kanayago::UndefNode

    assert_instance_of(Kanayago::UndefNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::UndefNode

    assert_instance_of(Kanayago::UndefNode, body)
  end
end
