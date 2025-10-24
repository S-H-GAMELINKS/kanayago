# frozen_string_literal: true

require_relative '../test_helper'

class ParseArgsCatTest < Minitest::Test
  def test_parse_args_concatenation
    result = Kanayago.parse('foo(a, *b)')

    assert_instance_of(Kanayago::ScopeNode, result)
    call_node = result.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    refute_nil(call_node.args)
  end

  def test_parse_args_concatenation_with_multiple_args
    result = Kanayago.parse('bar(x, y, *z)')

    assert_instance_of(Kanayago::ScopeNode, result)
    call_node = result.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    refute_nil(call_node.args)
  end
end
