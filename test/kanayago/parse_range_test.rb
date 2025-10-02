# frozen_string_literal: true

require_relative '../test_helper'

class ParseRangeTest < Minitest::Test
  def test_parse_inclusive_range
    result = Kanayago.parse(<<~CODE)
      1..10
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::RangeNode, body)

    assert_instance_of(Kanayago::IntegerNode, body.beg)

    assert_instance_of(Kanayago::IntegerNode, body.end)
  end

  def test_parse_exclusive_range
    result = Kanayago.parse(<<~CODE)
      1...10
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::ExclusiveRangeNode, body)

    assert_instance_of(Kanayago::IntegerNode, body.beg)

    assert_instance_of(Kanayago::IntegerNode, body.end)
  end

  def test_parse_range_with_variables
    result = Kanayago.parse(<<~CODE)
      x..y
    CODE

    body = result.body

    assert_instance_of(Kanayago::RangeNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.beg)
    assert_instance_of(Kanayago::VariableCallNode, body.end)
  end

  def test_parse_exclusive_range_with_variables
    result = Kanayago.parse(<<~CODE)
      a...b
    CODE

    body = result.body

    assert_instance_of(Kanayago::ExclusiveRangeNode, body)
    assert_instance_of(Kanayago::VariableCallNode, body.beg)
    assert_instance_of(Kanayago::VariableCallNode, body.end)
  end
end
