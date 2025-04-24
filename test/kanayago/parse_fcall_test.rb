# frozen_string_literal: true

require_relative '../test_helper'

class ParseFcallTest < Minitest::Test
  def test_parse_fcall
    result = Kanayago.parse('p 117')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::FunctionCallNode, body)
    assert_equal(:p, body.mid)
    assert_instance_of(Kanayago::ListNode, body.args)

    arg = body.args.val.first

    assert_instance_of(Kanayago::IntegerNode, arg)
  end
end
