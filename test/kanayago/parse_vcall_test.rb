# frozen_string_literal: true

require_relative '../test_helper'

class ParseVcallTest < Minitest::Test
  def test_parse_vcall
    result = Kanayago.parse('foo')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::VariableCallNode, body)
    assert_equal(:foo, body.mid)
  end

  def test_parse_vcall_with_underscore
    result = Kanayago.parse('foo_bar')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::VariableCallNode, body)
    assert_equal(:foo_bar, body.mid)
  end
end
