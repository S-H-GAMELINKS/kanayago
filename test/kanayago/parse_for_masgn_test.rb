# frozen_string_literal: true

require_relative '../test_helper'

class ParseForMasgnTest < Minitest::Test
  def test_parse_for_with_multiple_assignment
    result = Kanayago.parse('for a, b in [[1, 2]]; end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    for_node = result.ast.body

    assert_instance_of(Kanayago::ForNode, for_node)
    refute_nil(for_node.iter)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      for a, b in [[1, 2]]; end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ForNode
      assert_instance_of(Kanayago::ForNode, body)
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

    body in Kanayago::ForNode

    assert_instance_of(Kanayago::ForNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ForNode

    assert_instance_of(Kanayago::ForNode, body)
  end
end
