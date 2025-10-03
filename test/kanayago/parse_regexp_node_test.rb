# frozen_string_literal: true

require_relative '../test_helper'

class ParseRegexpNodeTest < Minitest::Test
  def test_parse_regexp_node
    result = Kanayago.parse('/hello/')

    body = result.body

    assert_instance_of(Kanayago::RegexpNode, body)
    assert_equal('hello', body.ptr)
    assert_equal(5, body.len)
  end

  def test_parse_regexp_node_with_options
    result = Kanayago.parse('/hello/i')

    body = result.body

    assert_instance_of(Kanayago::RegexpNode, body)
    assert_equal('hello', body.ptr)
    assert_equal(5, body.len)
    assert_equal(1, body.options)
  end
end
