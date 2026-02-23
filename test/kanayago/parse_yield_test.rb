# frozen_string_literal: true

require_relative '../test_helper'

class ParseYieldTest < Minitest::Test
  def test_parse_yield_no_args
    result = Kanayago.parse('def foo; yield; end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    definition_node = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, definition_node)
    scope_node = definition_node.defn

    assert_instance_of(Kanayago::ScopeNode, scope_node)
    yield_node = scope_node.body

    assert_instance_of(Kanayago::YieldNode, yield_node)
    assert_nil(yield_node.head)
  end

  def test_parse_yield_single_arg
    result = Kanayago.parse('def foo; yield 42; end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    definition_node = result.ast.body
    scope_node = definition_node.defn
    yield_node = scope_node.body

    assert_instance_of(Kanayago::YieldNode, yield_node)
    assert_instance_of(Kanayago::ListNode, yield_node.head)
    assert_equal(1, yield_node.head.len)
  end

  def test_parse_yield_multiple_args
    result = Kanayago.parse('def foo; yield 1, 2, 3; end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    definition_node = result.ast.body
    scope_node = definition_node.defn
    yield_node = scope_node.body

    assert_instance_of(Kanayago::YieldNode, yield_node)
    assert_instance_of(Kanayago::ListNode, yield_node.head)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      def foo; yield; end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::DefinitionNode
      assert_instance_of(Kanayago::DefinitionNode, body)
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

    body in Kanayago::DefinitionNode

    assert_instance_of(Kanayago::DefinitionNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::DefinitionNode

    assert_instance_of(Kanayago::DefinitionNode, body)
  end
end
