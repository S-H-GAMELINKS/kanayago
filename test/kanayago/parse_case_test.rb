# frozen_string_literal: true

require_relative '../test_helper'

class ParseCaseTest < Minitest::Test
  def test_parse_case_when
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      when 2
        puts "two"
      else
        puts "other"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::CaseNode, body)

    assert_instance_of(Kanayago::VariableCallNode, body.head)

    assert_instance_of(Kanayago::WhenNode, body.body)
  end

  def test_parse_case_single_when
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::CaseNode, body)

    assert_instance_of(Kanayago::VariableCallNode, body.head)
    assert_instance_of(Kanayago::WhenNode, body.body)
  end
end
