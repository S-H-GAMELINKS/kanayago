# frozen_string_literal: true

require_relative '../test_helper'

class ParseForMasgnTest < Minitest::Test
  def test_parse_for_with_multiple_assignment
    result = Kanayago.parse('for a, b in [[1, 2]]; end')

    assert_instance_of(Kanayago::ScopeNode, result)
    for_node = result.body

    assert_instance_of(Kanayago::ForNode, for_node)
    refute_nil(for_node.iter)
  end
end
