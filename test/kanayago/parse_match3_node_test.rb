# frozen_string_literal: true

require_relative '../test_helper'

class ParseMatch3NodeTest < Minitest::Test
  def test_parse_match3_node
    result = Kanayago.parse('"bar" =~ /foo#{1}/')

    body = result.body

    assert_instance_of(Kanayago::Match3Node, body)
    assert_instance_of(Kanayago::DynamicRegexpNode, body.recv)
    assert_instance_of(Kanayago::StringNode, body.value)
    assert_equal('bar', body.value.ptr)
  end

  def test_parse_match3_node_with_variable
    result = Kanayago.parse('x = 1; "test" =~ /pattern#{x}/')

    block = result.body
    match3_node = block[1]

    assert_instance_of(Kanayago::Match3Node, match3_node)
    assert_instance_of(Kanayago::DynamicRegexpNode, match3_node.recv)
    assert_instance_of(Kanayago::StringNode, match3_node.value)
  end
end
