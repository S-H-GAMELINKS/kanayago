# frozen_string_literal: true

require_relative '../test_helper'

class ParseRedoTest < Minitest::Test
  def test_parse_redo_basic
    result = Kanayago.parse('loop { redo }')
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    iter_body = body.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)
    assert_instance_of(Kanayago::RedoNode, iter_body.body)
  end

  def test_parse_redo_conditional
    result = Kanayago.parse('loop { redo if true }')
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    iter_body = body.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)
    assert_instance_of(Kanayago::IfStatementNode, iter_body.body)
    assert_instance_of(Kanayago::RedoNode, iter_body.body.body)
  end

  def test_parse_redo_in_iterator
    result = Kanayago.parse('3.times { redo }')
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    iter_body = body.body

    assert_instance_of(Kanayago::ScopeNode, iter_body)
    assert_instance_of(Kanayago::RedoNode, iter_body.body)
  end
end
