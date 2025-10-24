# frozen_string_literal: true

require_relative '../test_helper'

class ParseBlockPassTest < Minitest::Test
  def test_parse_block_pass_symbol_to_proc
    result = Kanayago.parse('[1, 2].map(&:to_s)')

    assert_instance_of(Kanayago::ScopeNode, result)
    call_node = result.body

    assert_instance_of(Kanayago::CallNode, call_node)
    assert_equal(:map, call_node.mid)

    block_pass_node = call_node.args

    assert_instance_of(Kanayago::BlockPassNode, block_pass_node)
    assert_instance_of(Kanayago::SymbolNode, block_pass_node.body)
    refute(block_pass_node.forwarding)
  end

  def test_parse_block_pass_variable
    result = Kanayago.parse('foo(&block)')

    assert_instance_of(Kanayago::ScopeNode, result)
    call_node = result.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    assert_equal(:foo, call_node.mid)

    block_pass_node = call_node.args

    assert_instance_of(Kanayago::BlockPassNode, block_pass_node)
    assert_instance_of(Kanayago::VariableCallNode, block_pass_node.body)
    refute(block_pass_node.forwarding)
  end

  def test_parse_block_pass_in_method_definition
    result = Kanayago.parse('def bar(&blk); end')

    assert_instance_of(Kanayago::ScopeNode, result)
    defn = result.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    assert_equal(:bar, defn.mid)

    scope_node = defn.defn

    assert_instance_of(Kanayago::ScopeNode, scope_node)

    args_node = scope_node.args

    assert_instance_of(Kanayago::ArgumentsNode, args_node)
  end
end
