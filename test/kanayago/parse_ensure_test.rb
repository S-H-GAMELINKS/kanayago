# frozen_string_literal: true

require_relative '../test_helper'

class ParseEnsureTest < Minitest::Test
  def test_parse_ensure_basic
    result = Kanayago.parse(<<~CODE)
      begin
        foo
      ensure
        bar
      end
    CODE

    body = result.body

    assert_instance_of(Kanayago::EnsureNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.head)
    assert_instance_of(Kanayago::VariableCallNode, body.ensr)
  end

  def test_parse_ensure_with_rescue
    result = Kanayago.parse(<<~CODE)
      begin
        foo
      rescue
        bar
      ensure
        baz
      end
    CODE

    body = result.body

    assert_instance_of(Kanayago::EnsureNode, body)
    assert_instance_of(Kanayago::RescueNode, body.head)
    assert_instance_of(Kanayago::VariableCallNode, body.ensr)
  end

  def test_parse_ensure_with_multiple_statements
    result = Kanayago.parse(<<~CODE)
      begin
        a = 1
        b = 2
      ensure
        c = 3
      end
    CODE

    body = result.body

    assert_instance_of(Kanayago::EnsureNode, body)
    refute_nil(body.head)
    refute_nil(body.ensr)
  end
end
