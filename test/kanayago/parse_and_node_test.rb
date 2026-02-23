# frozen_string_literal: true

require_relative '../test_helper'

class ParseAndNodeTest < Minitest::Test
  def test_parse_and_node
    result = Kanayago.parse('1 && 2')

    body = result.ast.body

    assert_instance_of(Kanayago::AndNode, body)
    assert_instance_of(Kanayago::IntegerNode, body.first)
    assert_instance_of(Kanayago::IntegerNode, body.second)
  end

  def test_case_in_matched
    result = Kanayago.parse('1 && 2')

    body = result.ast.body

    case body
    in Kanayago::AndNode(first:, second:)
      assert_instance_of(Kanayago::IntegerNode, first)
      assert_instance_of(Kanayago::IntegerNode, second)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('1 && 2')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::AndNode(first: Kanayago::StringNode, second:)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('1 && 2')

    body = result.ast.body

    body in Kanayago::AndNode(first:, second:)

    assert_instance_of(Kanayago::IntegerNode, first)
    assert_instance_of(Kanayago::IntegerNode, second)
  end

  def test_right_assignment
    result = Kanayago.parse('1 && 2')

    body = result.ast.body

    body => Kanayago::AndNode(first:, second:)

    assert_instance_of(Kanayago::IntegerNode, first)
    assert_instance_of(Kanayago::IntegerNode, second)
  end
end
