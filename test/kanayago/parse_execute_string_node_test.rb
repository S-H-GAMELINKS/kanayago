# frozen_string_literal: true

require_relative '../test_helper'

class ParseExecuteStringNodeTest < Minitest::Test
  def test_parse_execute_string_node
    result = Kanayago.parse('`echo hello`')

    body = result.body

    assert_instance_of(Kanayago::ExecuteStringNode, body)
    assert_equal('echo hello', body.ptr)
    assert_equal(10, body.len)
  end
end
