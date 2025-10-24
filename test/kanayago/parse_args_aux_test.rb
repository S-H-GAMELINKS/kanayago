# frozen_string_literal: true

require_relative '../test_helper'

class ParseArgsAuxTest < Minitest::Test
  def test_parse_method_with_optional_args
    result = Kanayago.parse('def foo(a, b = 1); end')

    assert_instance_of(Kanayago::ScopeNode, result)
    defn = result.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def test_parse_method_with_multiple_args
    result = Kanayago.parse('def bar(x, y, z = 2); end')

    assert_instance_of(Kanayago::ScopeNode, result)
    defn = result.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end
end
