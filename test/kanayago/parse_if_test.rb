# frozen_string_literal: true

require_relative '../test_helper'

class ParseIfTest < Minitest::Test
  def test_parse_if
    result = Kanayago.parse(<<~CODE)
      v = 117
      if v
        p v
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    arg = body.first

    assert_instance_of(Kanayago::LocalAssignmentNode, arg)

    arg = body.last

    assert_instance_of(Kanayago::IfStatementNode, arg)
  end
end
