# frozen_string_literal: true

require_relative '../test_helper'

class ParseConstDeclTest < Minitest::Test
  def test_parse_const_decl
    result = Kanayago.parse('S = 117')

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::ConstantDeclarationNode, body)
    assert_equal(:S, body.vid)
    assert_nil(body.else)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end
end
