# frozen_string_literal: true

require_relative '../test_helper'

class ParseHashTest < Minitest::Test
  def test_parse_empty_hash
    result = Kanayago.parse('{}')
    body = result.ast.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
    assert_nil(body.head)
  end

  def test_parse_hash_with_symbol_keys
    result = Kanayago.parse('{a: 1, b: 2}')
    body = result.ast.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
    assert_instance_of(Kanayago::ListNode, body.head)
  end

  def test_parse_hash_with_string_keys
    result = Kanayago.parse('{"key" => "value"}')
    body = result.ast.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
    assert_instance_of(Kanayago::ListNode, body.head)
  end

  def test_parse_nested_hash
    result = Kanayago.parse('{a: {b: 1}}')
    body = result.ast.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      {}
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::HashNode
      assert_instance_of(Kanayago::HashNode, body)
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

    body in Kanayago::HashNode

    assert_instance_of(Kanayago::HashNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::HashNode

    assert_instance_of(Kanayago::HashNode, body)
  end
end
