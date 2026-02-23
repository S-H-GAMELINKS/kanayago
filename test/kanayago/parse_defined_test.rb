# frozen_string_literal: true

require_relative '../test_helper'

class ParseDefinedTest < Minitest::Test
  def test_parse_defined_basic_variable
    result = Kanayago.parse('defined? x')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.head)
  end

  def test_parse_defined_instance_variable
    result = Kanayago.parse('defined? @ivar')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::InstanceVariableNode, body.head)
  end

  def test_parse_defined_class_variable
    result = Kanayago.parse('defined? @@cvar')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::ClassVariableNode, body.head)
  end

  def test_parse_defined_global_variable
    result = Kanayago.parse('defined? $gvar')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::GlobalVariableNode, body.head)
  end

  def test_parse_defined_constant
    result = Kanayago.parse('defined? CONST')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::ConstantNode, body.head)
  end

  def test_parse_defined_nested_constant
    result = Kanayago.parse('defined? Foo::Bar')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::Colon2Node, body.head)
  end

  def test_parse_defined_method_call
    result = Kanayago.parse('defined? method_name')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.head)
  end

  def test_parse_defined_in_condition
    result = Kanayago.parse('if defined?(x); puts "defined"; end')
    body = result.ast.body

    assert_instance_of(Kanayago::IfStatementNode, body)
    assert_instance_of(Kanayago::DefinedNode, body.cond)
  end

  def test_parse_defined_in_assignment
    result = Kanayago.parse('result = defined?(x)')
    body = result.ast.body

    assert_instance_of(Kanayago::LocalAssignmentNode, body)
    assert_instance_of(Kanayago::DefinedNode, body.value)
  end

  def test_parse_defined_nested
    result = Kanayago.parse('defined?(defined?(x))')
    body = result.ast.body

    assert_instance_of(Kanayago::DefinedNode, body)
    assert_instance_of(Kanayago::DefinedNode, body.head)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      defined? x
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::DefinedNode
      assert_instance_of(Kanayago::DefinedNode, body)
    end
  end

  def test_case_in_unmatched
    body = pattern_match_target_body

    assert_raises(NoMatchingPatternError) do
      case body.class.name
      in '__kanayago_unmatched_pattern__'
        # Nothing to do
      end
    end
  end

  def test_single_in
    body = pattern_match_target_body

    body in Kanayago::DefinedNode

    assert_instance_of(Kanayago::DefinedNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::DefinedNode

    assert_instance_of(Kanayago::DefinedNode, body)
  end
end
