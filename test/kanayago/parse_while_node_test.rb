# frozen_string_literal: true

require_relative '../test_helper'

class ParseWhileNodeTest < Minitest::Test
  def test_parse_while_node
    result = Kanayago.parse(<<~CODE)
      v = 115

      while (v == 117) do
        v += 1
      end
    CODE

    result.ast.body
    line = result.ast.body.last

    assert_instance_of(Kanayago::WhileNode, line)
    assert_equal(1, line.state)
    assert_instance_of(Kanayago::OperatorCallNode, line.cond.first)
    assert_instance_of(Kanayago::LocalAssignmentNode, line.body)
  end
end
