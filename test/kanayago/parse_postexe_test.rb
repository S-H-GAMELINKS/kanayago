# frozen_string_literal: true

require_relative '../test_helper'

class ParsePostexeTest < Minitest::Test
  def test_parse_end_block
    result = Kanayago.parse('END { puts "goodbye" }')

    assert_instance_of(Kanayago::ScopeNode, result)
    postexe_node = result.body

    assert_instance_of(Kanayago::PostexeNode, postexe_node)
    refute_nil(postexe_node.body)
  end
end
