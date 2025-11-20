# frozen_string_literal: true

require_relative '../test_helper'

class ParseMatch2NodeTest < Minitest::Test
  def test_parse_match2_node
    result = Kanayago.parse('/foo/ =~ "bar"')

    body = result.ast.body

    assert_instance_of(Kanayago::Match2Node, body)
    assert_instance_of(Kanayago::RegexpNode, body.recv)
    assert_instance_of(Kanayago::StringNode, body.value)
    assert_equal('foo', body.recv.ptr)
  end

  def test_parse_match2_node_with_captures
    result = Kanayago.parse('/(?<name>\w+)/ =~ "test"')

    body = result.ast.body

    assert_instance_of(Kanayago::Match2Node, body)
    # nd_args should contain capture assignments when named captures exist
    refute_nil(body.args) if body.recv.ptr.include?('?<')
  end
end
