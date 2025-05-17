# frozen_string_literal: true

require_relative '../test_helper'

class ParseUnlessTest < Minitest::Test
  def test_parse_unless
    result = Kanayago.parse(<<~CODE)
      v = 117
      unless v
        p v
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    line = body[0]

    assert_instance_of(Kanayago::LocalAssignmentNode, line)

    line = body[1]

    assert_instance_of(Kanayago::UnlessStatementNode, line)
    assert_instance_of(Kanayago::LocalVariableNode, line.cond)
    assert_instance_of(Kanayago::FunctionCallNode, line.body)
    assert_nil(line.else)
  end
end
