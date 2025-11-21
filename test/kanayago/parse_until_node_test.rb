# frozen_string_literal: true

require_relative '../test_helper'

class ParseUntilNodeTest < Minitest::Test
  def test_parse_while_node
    result = Kanayago.parse(<<~CODE)
      v = 115

      until (v == 117) do
        v += 1
      end
    CODE

    line = result.ast.body.last

    assert_instance_of(Kanayago::UntilNode, line)
    assert_equal(1, line.state)
    assert_instance_of(Kanayago::OperatorCallNode, line.cond.first)
    assert_instance_of(Kanayago::LocalAssignmentNode, line.body)
  end
end
