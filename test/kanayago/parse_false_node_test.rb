# frozen_string_literal: true

require_relative '../test_helper'

class ParseFalseNodeTest < Minitest::Test
  def test_parse_false_node
    result = Kanayago.parse('false')

    body = result.body

    assert_instance_of(Kanayago::FalseNode, body)
    refute(body.val)
  end
end
