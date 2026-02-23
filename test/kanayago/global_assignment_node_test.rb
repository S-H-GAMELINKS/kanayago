# frozen_string_literal: true

require_relative '../test_helper'

class ParseGlobalAssignmentNodeTest < Minitest::Test
  def test_parse_global_assignment_node
    result = Kanayago.parse('$var = 117')

    body = result.ast.body

    assert_instance_of(Kanayago::GlobalAssignmentNode, body)
    assert_equal(:$var, body.id)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end

  def test_case_in_matched
    result = Kanayago.parse('$var = 117')

    body = result.ast.body

    case body
    in Kanayago::GlobalAssignmentNode(id: :$var, value: Kanayago::IntegerNode)
      assert(true)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('$var = 117')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::GlobalAssignmentNode(id: :var, value: nil)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('$var = 117')

    body = result.ast.body

    body in Kanayago::GlobalAssignmentNode(id:, value:)

    assert_equal(:$var, id)
    assert_instance_of(Kanayago::IntegerNode, value)
  end

  def test_right_assignment
    result = Kanayago.parse('$var = 117')

    body = result.ast.body

    body => Kanayago::GlobalAssignmentNode(id:, value:)

    assert_equal(:$var, id)
    assert_instance_of(Kanayago::IntegerNode, value)
  end
end
