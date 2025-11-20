# frozen_string_literal: true

require_relative '../test_helper'

class ParseOrNode < Minitest::Test
  def test_parse_or_node
    result = Kanayago.parse('1 || 2')

    body = result.ast.body

    assert_instance_of(Kanayago::OrNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.first)
    assert_instance_of(Kanayago::IntegerNode, body.second)
  end
end
