# frozen_string_literal: true

require_relative '../test_helper'

class ParseReturnNode < Minitest::Test
  def test_parse_single_statement_return_node
    result = Kanayago.parse(<<~CODE)
      return 117
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ReturnNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.statements)
  end

  def test_parse_multiple_statement_return_node
    result = Kanayago.parse(<<~CODE)
      return 117, 34
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ReturnNode, body)
    assert_instance_of(Kanayago::ListNode, body.statements)
    assert_instance_of(Kanayago::IntegerNode, body.statements.val.first)
    assert_instance_of(Kanayago::IntegerNode, body.statements.val.last)
  end
end
