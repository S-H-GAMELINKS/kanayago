# frozen_string_literal: true

require_relative '../test_helper'

class ParseMasgnTest < Minitest::Test
  def test_parse_multiple_assignment
    result = Kanayago.parse('a, b = 1, 2')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    masgn_node = result.ast.body

    assert_instance_of(Kanayago::MasgnNode, masgn_node)
    refute_nil(masgn_node.head)
  end

  def test_parse_multiple_assignment_with_array
    result = Kanayago.parse('a, b = [1, 2]')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    refute_nil(result.ast.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      a, b = 1, 2
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::MasgnNode
      assert_instance_of(Kanayago::MasgnNode, body)
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

    body in Kanayago::MasgnNode

    assert_instance_of(Kanayago::MasgnNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::MasgnNode

    assert_instance_of(Kanayago::MasgnNode, body)
  end
end
