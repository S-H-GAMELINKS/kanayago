# frozen_string_literal: true

require_relative '../test_helper'

class ParseIvarTest < Minitest::Test
  def test_parse_ivar
    result = Kanayago.parse('@kanayago')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::InstanceVariableNode, body)
    assert_equal(:@kanayago, body.vid)
  end
end
