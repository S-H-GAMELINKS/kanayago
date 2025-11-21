# frozen_string_literal: true

require_relative '../test_helper'

class ParseKwArgTest < Minitest::Test
  def test_parse_keyword_argument_with_default
    result = Kanayago.parse('def foo(bar: 1); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end
end
