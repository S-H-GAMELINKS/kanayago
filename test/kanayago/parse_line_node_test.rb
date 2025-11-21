# frozen_string_literal: true

require_relative '../test_helper'

class ParseLineNodeTest < Minitest::Test
  def test_parse_line_node
    result = Kanayago.parse('__LINE__')

    body = result.ast.body

    assert_instance_of(Kanayago::LineNode, body)
    assert_equal(0, body.lineno)
  end
end
