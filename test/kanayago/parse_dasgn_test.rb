# frozen_string_literal: true

require_relative '../test_helper'

class ParseDasgnTest < Minitest::Test
  def test_parse_dynamic_assignment_in_block
    result = Kanayago.parse('1.times { a = 1 }')

    assert_instance_of(Kanayago::ScopeNode, result)
    iter_node = result.body

    assert_instance_of(Kanayago::IterNode, iter_node)
    refute_nil(iter_node.iter)
  end
end
