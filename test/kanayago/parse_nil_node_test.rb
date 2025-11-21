# frozen_string_literal: true

require_relative '../test_helper'

class ParseNilNodeTest < Minitest::Test
  def test_parse_nil_node
    result = Kanayago.parse('nil')

    body = result.ast.body

    assert_instance_of(Kanayago::NilNode, body)
    assert_nil(body.val)
  end
end
