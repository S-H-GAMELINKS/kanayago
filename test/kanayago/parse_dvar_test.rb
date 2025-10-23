# frozen_string_literal: true

require_relative '../test_helper'

class ParseDvarTest < Minitest::Test
  def test_parse_dvar_in_lambda
    result = Kanayago.parse(<<~CODE)
      x = 1
      lambda { x }
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    first_line = body.first

    assert_instance_of(Kanayago::LocalAssignmentNode, first_line)
    assert_equal(:x, first_line.id)

    second_line = body.last

    assert_instance_of(Kanayago::IterNode, second_line)

    lambda_body = second_line.body.body

    assert_instance_of(Kanayago::DynamicVariableNode, lambda_body)
    assert_equal(:x, lambda_body.vid)
  end

  def test_parse_dvar_in_block
    result = Kanayago.parse(<<~CODE)
      x = 10
      [1, 2, 3].each do |i|
        puts x
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)

    iter_node = body.last

    assert_instance_of(Kanayago::IterNode, iter_node)

    block_body = iter_node.body.body

    assert_instance_of(Kanayago::FunctionCallNode, block_body)

    arg = block_body.args.val.first

    assert_instance_of(Kanayago::DynamicVariableNode, arg)
    assert_equal(:x, arg.vid)
  end

  def test_parse_dvar_in_proc
    result = Kanayago.parse(<<~CODE)
      value = 42
      proc { value }
    CODE

    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)

    proc_node = body.last

    assert_instance_of(Kanayago::IterNode, proc_node)

    proc_body = proc_node.body.body

    assert_instance_of(Kanayago::DynamicVariableNode, proc_body)
    assert_equal(:value, proc_body.vid)
  end
end
