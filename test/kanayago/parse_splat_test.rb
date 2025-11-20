# frozen_string_literal: true

require_relative '../test_helper'

class ParseSplatTest < Minitest::Test
  def test_parse_splat_in_method_call
    result = Kanayago.parse('foo(*args)')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    call_node = result.ast.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    splat_node = call_node.args

    assert_instance_of(Kanayago::SplatNode, splat_node)
    assert_instance_of(Kanayago::VariableCallNode, splat_node.head)
  end

  def test_parse_splat_with_multiple_args
    result = Kanayago.parse('bar(1, *rest, 2)')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    call_node = result.ast.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    refute_nil(call_node.args)
  end

  def test_parse_splat_in_send
    result = Kanayago.parse('[1, 2].each { |x| puts(*x) }')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    iter_node = result.ast.body

    assert_instance_of(Kanayago::IterNode, iter_node)
  end
end
