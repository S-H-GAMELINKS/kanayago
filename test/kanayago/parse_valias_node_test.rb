# frozen_string_literal: true

require_relative '../test_helper'

class ParseValiasNodeTest < Minitest::Test
  def test_parse_valias_node
    result = Kanayago.parse('alias $v $g')

    body = result.body

    assert_instance_of(Kanayago::ValiasNode, body)
    assert_equal(:$v, body.alias)
    assert_equal(:$g, body.original)
  end
end
