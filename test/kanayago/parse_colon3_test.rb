# frozen_string_literal: true

require_relative '../test_helper'

class ParseColon3Test < Minitest::Test
  def test_parse_colon3_node
    result = Kanayago.parse('::String')

    body = result.ast.body

    assert_instance_of(Kanayago::Colon3Node, body)
    assert_equal(:String, body.mid)
  end
end
