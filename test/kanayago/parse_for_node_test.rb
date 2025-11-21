# frozen_string_literal: true

require_relative '../test_helper'

class ParseForNodeTest < Minitest::Test
  def test_parse_for_node
    result = Kanayago.parse(<<~CODE)
      for i in [1, 2, 3] do
        p i
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ForNode, body)
    assert_instance_of(Kanayago::ListNode, body.iter)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end
end
