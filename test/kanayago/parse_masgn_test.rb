# frozen_string_literal: true

require_relative '../test_helper'

class ParseMasgnTest < Minitest::Test
  def test_parse_multiple_assignment
    result = Kanayago.parse('a, b = 1, 2')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    masgn_node = result.ast.body

    assert_instance_of(Kanayago::MasgnNode, masgn_node)
    refute_nil(masgn_node.head)
  end

  def test_parse_multiple_assignment_with_array
    result = Kanayago.parse('a, b = [1, 2]')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    refute_nil(result.ast.body)
  end
end
