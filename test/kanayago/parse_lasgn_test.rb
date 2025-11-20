# frozen_string_literal: true

require_relative '../test_helper'

class ParseLasgnTest < Minitest::Test
  def test_parse_lasgn
    result = Kanayago.parse('var = 117')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::LocalAssignmentNode, body)
    assert_equal(:var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)

    value = body.value

    assert_equal(117, value.val)
  end
end
