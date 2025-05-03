# frozen_string_literal: true

require_relative '../test_helper'

class ParseSelfNodeTest < Minitest::Test
  def test_parse_true_node
    result = Kanayago.parse('self')

    body = result.body

    assert_instance_of(Kanayago::SelfNode, body)
    assert_equal(1, body.state)
  end
end
