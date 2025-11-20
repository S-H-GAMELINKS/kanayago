# frozen_string_literal: true

require_relative '../test_helper'

class ParseRescueTest < Minitest::Test
  def test_parse_rescue_basic
    result = Kanayago.parse(<<~CODE)
      begin
        1 / 0
      rescue
        puts "error"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    refute_nil(body.head)
    assert_instance_of(Kanayago::RescueBodyNode, body.resq)
  end

  def test_parse_rescue_with_exception_class
    result = Kanayago.parse(<<~CODE)
      begin
        raise StandardError
      rescue StandardError
        puts "caught"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    assert_instance_of(Kanayago::RescueBodyNode, body.resq)
  end

  def test_parse_rescue_with_else
    result = Kanayago.parse(<<~CODE)
      begin
        foo
      rescue
        bar
      else
        baz
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    refute_nil(body.else)
  end

  def test_parse_rescue_multiple_clauses
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue ArgumentError
        puts "arg error"
      rescue StandardError
        puts "std error"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::RescueNode, body)
    first_resbody = body.resq

    assert_instance_of(Kanayago::RescueBodyNode, first_resbody)
    assert_instance_of(Kanayago::RescueBodyNode, first_resbody.next)
  end
end
