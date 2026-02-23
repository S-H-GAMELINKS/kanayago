# frozen_string_literal: true

require_relative '../test_helper'

class ParseArgsAuxTest < Minitest::Test
  def test_parse_method_with_optional_args
    result = Kanayago.parse('def foo(a, b = 1); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def test_parse_method_with_multiple_args
    result = Kanayago.parse('def bar(x, y, z = 2); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def test_case_in_matched
    result = Kanayago.parse('def foo(a, b = 1); end')

    body = result.ast.body

    case body
    in Kanayago::DefinitionNode(mid: :foo, defn:)
      assert_instance_of(Kanayago::ScopeNode, defn)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('def foo(a, b = 1); end')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::DefinitionNode(mid: :bar, defn:)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('def foo(a, b = 1); end')

    body = result.ast.body

    body in Kanayago::DefinitionNode(mid: :foo, defn:)

    assert_instance_of(Kanayago::ScopeNode, defn)
  end

  def test_right_assignment
    result = Kanayago.parse('def foo(a, b = 1); end')

    body = result.ast.body

    body => Kanayago::DefinitionNode(mid: :foo, defn:)

    assert_instance_of(Kanayago::ScopeNode, defn)
  end
end
