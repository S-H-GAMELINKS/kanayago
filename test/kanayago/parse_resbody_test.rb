# frozen_string_literal: true

require_relative '../test_helper'

class ParseRescueBodyTest < Minitest::Test
  def test_parse_resbody_with_exception_variable
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue => e
        puts e
      end
    CODE

    body = result.ast.body
    rescue_node = body

    assert_instance_of(Kanayago::RescueNode, rescue_node)
    resbody = rescue_node.resq

    assert_instance_of(Kanayago::RescueBodyNode, resbody)
    assert_instance_of(Kanayago::LocalAssignmentNode, resbody.exc_var)
  end

  def test_parse_resbody_with_exception_class_and_variable
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue StandardError => e
        puts e
      end
    CODE

    body = result.ast.body
    rescue_node = body

    assert_instance_of(Kanayago::RescueNode, rescue_node)
    resbody = rescue_node.resq

    assert_instance_of(Kanayago::RescueBodyNode, resbody)
    refute_nil(resbody.args)
    assert_instance_of(Kanayago::LocalAssignmentNode, resbody.exc_var)
  end

  def test_parse_multiple_rescue_clauses
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
    rescue_node = body

    assert_instance_of(Kanayago::RescueNode, rescue_node)
    first_resbody = rescue_node.resq

    assert_instance_of(Kanayago::RescueBodyNode, first_resbody)

    second_resbody = first_resbody.next

    refute_nil(second_resbody)
    assert_instance_of(Kanayago::RescueBodyNode, second_resbody)
  end

  def test_parse_resbody_without_exception_variable
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue StandardError
        puts "error"
      end
    CODE

    body = result.ast.body
    rescue_node = body

    assert_instance_of(Kanayago::RescueNode, rescue_node)
    resbody = rescue_node.resq

    assert_instance_of(Kanayago::RescueBodyNode, resbody)
    refute_nil(resbody.args)
  end
end
