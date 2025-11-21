# frozen_string_literal: true

require_relative '../test_helper'

class ParseZeroListTest < Minitest::Test
  def test_parse_zero_list
    result = Kanayago.parse('[]')

    body = result.ast.body

    assert_instance_of(Kanayago::ZeroListNode, body)
    assert_equal(0, body.len)
    assert_empty(body.val)
  end
end
