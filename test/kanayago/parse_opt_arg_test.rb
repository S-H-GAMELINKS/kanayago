# frozen_string_literal: true

require_relative '../test_helper'

class ParseOptArgTest < Minitest::Test
  def test_parse_optional_argument
    result = Kanayago.parse('def foo(a = 1); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def test_parse_multiple_optional_arguments
    result = Kanayago.parse('def bar(a = 1, b = 2); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end
end
