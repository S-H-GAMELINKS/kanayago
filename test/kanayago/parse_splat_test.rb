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

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      foo(*args)
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::FunctionCallNode
      assert_instance_of(Kanayago::FunctionCallNode, body)
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

    body in Kanayago::FunctionCallNode

    assert_instance_of(Kanayago::FunctionCallNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::FunctionCallNode

    assert_instance_of(Kanayago::FunctionCallNode, body)
  end
end
