# frozen_string_literal: true

require_relative '../test_helper'

class ParseCase2Test < Minitest::Test
  def test_parse_case_without_condition
    result = Kanayago.parse(<<~CODE)
      case
      when true
        puts "yes"
      when false
        puts "no"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::Case2Node, body)

    assert_instance_of(Kanayago::WhenNode, body.body)
  end

  def test_parse_case_without_condition_single_when
    result = Kanayago.parse(<<~CODE)
      case
      when 1 == 1
        puts "match"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::Case2Node, body)

    assert_instance_of(Kanayago::WhenNode, body.body)
  end
end
