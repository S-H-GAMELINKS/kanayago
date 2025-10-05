# frozen_string_literal: true

require_relative '../test_helper'

class ParseHashTest < Minitest::Test
  def test_parse_empty_hash
    result = Kanayago.parse('{}')
    body = result.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
    assert_nil(body.head)
  end

  def test_parse_hash_with_symbol_keys
    result = Kanayago.parse('{a: 1, b: 2}')
    body = result.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
    assert_instance_of(Kanayago::ListNode, body.head)
  end

  def test_parse_hash_with_string_keys
    result = Kanayago.parse('{"key" => "value"}')
    body = result.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
    assert_instance_of(Kanayago::ListNode, body.head)
  end

  def test_parse_nested_hash
    result = Kanayago.parse('{a: {b: 1}}')
    body = result.body

    assert_instance_of(Kanayago::HashNode, body)
    assert(body.brace)
  end
end
