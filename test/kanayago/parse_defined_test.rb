# frozen_string_literal: true

require_relative '../test_helper'

class ParseDefinedTest < Minitest::Test
  def test_parse_defined_basic_variable
    result = Kanayago.parse('defined? x')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.head)
  end

  def test_parse_defined_instance_variable
    result = Kanayago.parse('defined? @ivar')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::InstanceVariableNode, body.head)
  end

  def test_parse_defined_class_variable
    result = Kanayago.parse('defined? @@cvar')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::ClassVariableNode, body.head)
  end

  def test_parse_defined_global_variable
    result = Kanayago.parse('defined? $gvar')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::GlobalVariableNode, body.head)
  end

  def test_parse_defined_constant
    result = Kanayago.parse('defined? CONST')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::ConstantNode, body.head)
  end

  def test_parse_defined_nested_constant
    result = Kanayago.parse('defined? Foo::Bar')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::Colon2Node, body.head)
  end

  def test_parse_defined_method_call
    result = Kanayago.parse('defined? method_name')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.head)
  end

  def test_parse_defined_in_condition
    result = Kanayago.parse('if defined?(x); puts "defined"; end')
    body = result.body

    assert_instance_of(Kanayago::IfStatementNode, body)
    assert_instance_of(Kanayago::DefinedNode, body.cond)
  end

  def test_parse_defined_in_assignment
    result = Kanayago.parse('result = defined?(x)')
    body = result.body

    assert_instance_of(Kanayago::LocalAssignmentNode, body)
    assert_instance_of(Kanayago::DefinedNode, body.value)
  end

  def test_parse_defined_nested
    result = Kanayago.parse('defined?(defined?(x))')
    body = result.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::DefinedNode, body.head)
  end
end
