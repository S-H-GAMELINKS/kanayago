# frozen_string_literal: true

require_relative '../test_helper'

class ParsePostArgTest < Minitest::Test
  def test_parse_post_argument
    result = Kanayago.parse('def foo(*args, a); end')

    assert_instance_of(Kanayago::ScopeNode, result)
    defn = result.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def test_parse_post_arguments_multiple
    result = Kanayago.parse('def bar(*args, a, b); end')

    assert_instance_of(Kanayago::ScopeNode, result)
    defn = result.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end
end
