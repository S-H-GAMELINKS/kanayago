# frozen_string_literal: true

require_relative '../test_helper'

class ParseMatchNodeTest < Minitest::Test
  def test_parse_match_node
    result = Kanayago.parse('if /hello/ then end')

    scope = result
    if_node = scope.body
    cond = if_node.cond

    assert_instance_of(Kanayago::MatchNode, cond)
    assert_equal('hello', cond.ptr)
    assert_equal(5, cond.len)
  end

  def test_parse_match_node_with_options
    result = Kanayago.parse('if /hello/i then end')

    scope = result
    if_node = scope.body
    cond = if_node.cond

    assert_instance_of(Kanayago::MatchNode, cond)
    assert_equal('hello', cond.ptr)
    assert_equal(1, cond.options)
  end
end
