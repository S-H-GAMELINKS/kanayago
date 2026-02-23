# frozen_string_literal: true

require_relative '../test_helper'

class ParseArgsPushTest < Minitest::Test
  def test_parse_args_push
    result = Kanayago.parse('foo(*a, b)')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    call_node = result.ast.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    refute_nil(call_node.args)
  end

  def test_parse_args_push_with_multiple_trailing
    result = Kanayago.parse('bar(*x, y, z)')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    call_node = result.ast.body

    assert_instance_of(Kanayago::FunctionCallNode, call_node)
    refute_nil(call_node.args)
  end

  def test_case_in_matched
    result = Kanayago.parse('foo(*a, b)')

    body = result.ast.body

    case body
    in Kanayago::FunctionCallNode(mid: :foo, args: Kanayago::ArgsPushNode)
      assert(true)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('foo(*a, b)')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::FunctionCallNode(mid: :bar, args:)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('foo(*a, b)')

    body = result.ast.body

    body in Kanayago::FunctionCallNode(mid: :foo, args: Kanayago::ArgsPushNode)

    assert_equal(:foo, body.mid)
  end

  def test_right_assignment
    result = Kanayago.parse('foo(*a, b)')

    body = result.ast.body

    body => Kanayago::FunctionCallNode(mid: :foo, args: Kanayago::ArgsPushNode)

    assert_equal(:foo, body.mid)
  end
end
