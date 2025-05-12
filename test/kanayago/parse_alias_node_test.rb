# frozen_string_literal: true

require_relative '../test_helper'

class ParseAliasNodeTest < Minitest::Test
  def test_parse_alias_node
    result = Kanayago.parse('alias v g')

    body = result.body

    assert_instance_of(Kanayago::AliasNode, body)
    assert_instance_of(Kanayago::SymbolNode, body.first)
    assert_instance_of(Kanayago::SymbolNode, body.second)
  end
end
