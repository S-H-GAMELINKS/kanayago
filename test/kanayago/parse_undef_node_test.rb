# frozen_string_literal: true

require_relative '../test_helper'

class ParseUndefNodeTest < Minitest::Test
  def test_parse_undef_node
    result = Kanayago.parse('undef :send')

    body = result.body

    assert_instance_of(Kanayago::UndefNode, body)
    assert_instance_of(Array, body.undefs)
    assert_equal(1, body.undefs.size)
    assert_instance_of(Kanayago::SymbolNode, body.undefs.first)
  end
end
