# frozen_string_literal: true

require_relative '../test_helper'

class ParseAttrasgnTest < Minitest::Test
  def test_parse_attrasgn_setter
    result = Kanayago.parse(<<~CODE)
      obj.attr = 117
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::AttributeAssignmentNode, body)
    assert_equal(:attr=, body.mid)
    assert_instance_of(Kanayago::VariableCallNode, body.recv)
    assert_instance_of(Kanayago::ListNode, body.args)
  end

  def test_parse_attrasgn_bracket
    result = Kanayago.parse(<<~CODE)
      obj[key] = value
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::AttributeAssignmentNode, body)
    assert_equal(:[]=, body.mid)
  end

  def test_case_in_matched
    result = Kanayago.parse('obj.attr = 117')

    body = result.ast.body

    case body
    in Kanayago::AttributeAssignmentNode(mid: :attr=, recv: Kanayago::VariableCallNode, args: Kanayago::ListNode)
      assert(true)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('obj.attr = 117')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::AttributeAssignmentNode(mid: :[]=, recv:, args:)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('obj.attr = 117')

    body = result.ast.body

    body in Kanayago::AttributeAssignmentNode(mid: :attr=, recv: Kanayago::VariableCallNode, args: Kanayago::ListNode)

    assert_equal(:attr=, body.mid)
  end

  def test_right_assignment
    result = Kanayago.parse('obj.attr = 117')

    body = result.ast.body

    body => Kanayago::AttributeAssignmentNode(mid: :attr=, recv: Kanayago::VariableCallNode, args: Kanayago::ListNode)

    assert_equal(:attr=, body.mid)
  end
end
