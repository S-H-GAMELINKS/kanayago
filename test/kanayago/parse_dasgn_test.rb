# frozen_string_literal: true

require_relative '../test_helper'

class ParseDasgnTest < Minitest::Test
  def test_parse_dynamic_assignment_in_block
    result = Kanayago.parse('1.times { a = 1 }')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    iter_node = result.ast.body

    assert_instance_of(Kanayago::IterNode, iter_node)
    refute_nil(iter_node.iter)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      1.times { a = 1 }
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
