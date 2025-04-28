# frozen_string_literal: true

require_relative '../test_helper'

class ParseTrueNodeTest < Minitest::Test
  def test_parse_true_node
    result = Kanayago.parse('true')

    body = result.body

    assert_instance_of(Kanayago::TrueNode, body)
    assert(body.val)
  end
end
