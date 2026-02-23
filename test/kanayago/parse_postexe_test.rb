# frozen_string_literal: true

require_relative '../test_helper'

class ParsePostexeTest < Minitest::Test
  def test_parse_end_block
    result = Kanayago.parse('END { puts "goodbye" }')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    postexe_node = result.ast.body

    assert_instance_of(Kanayago::PostexeNode, postexe_node)
    refute_nil(postexe_node.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      END { puts "goodbye" }
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::PostexeNode
      assert_instance_of(Kanayago::PostexeNode, body)
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

    body in Kanayago::PostexeNode

    assert_instance_of(Kanayago::PostexeNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::PostexeNode

    assert_instance_of(Kanayago::PostexeNode, body)
  end
end
