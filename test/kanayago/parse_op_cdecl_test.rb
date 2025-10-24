# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpCdeclTest < Minitest::Test
  def test_parse_op_cdecl_plus
    result = Kanayago.parse('Foo::CONST += 100')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
    assert_equal(:+, body.aid)
    assert_instance_of(Kanayago::Colon2Node, body.head)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end

  def test_parse_op_cdecl_multiply
    result = Kanayago.parse('Bar::MAX_VALUE *= 2')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
    assert_equal(:*, body.aid)
  end

  def test_parse_op_cdecl_scoped
    result = Kanayago.parse('Foo::Bar::CONST += 1')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
  end
end
