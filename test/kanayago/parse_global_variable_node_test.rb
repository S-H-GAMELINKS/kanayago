# frozen_string_literal: true

require_relative '../test_helper'

class ParseIvarTest < Minitest::Test
  def test_parse_ivar
    result = Kanayago.parse('$kanayago')
    body = result.ast.body

    assert_instance_of(Kanayago::GlobalVariableNode, body)
    assert_equal(:$kanayago, body.vid)
  end
end
