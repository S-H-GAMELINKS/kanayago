# frozen_string_literal: true

require_relative '../test_helper'

class ParseAliasNodeTest < Minitest::Test
  def test_parse_alias_node
    result = Kanayago.parse('alias v g')

    body = result.ast.body

    assert_instance_of(Kanayago::AliasNode, body)
    assert_instance_of(Kanayago::SymbolNode, body.first)
    assert_instance_of(Kanayago::SymbolNode, body.second)
  end

  def test_case_in_matched
    result = Kanayago.parse('alias v g')

    body = result.ast.body

    case body
    in Kanayago::AliasNode(first:, second:)
      assert_instance_of(Kanayago::SymbolNode, first)
      assert_instance_of(Kanayago::SymbolNode, second)
    end
  end

  def test_case_in_unmatched
    result = Kanayago.parse('alias v g')

    body = result.ast.body

    assert_raises(NoMatchingPatternError) do
      case body
      in Kanayago::AliasNode(first: Kanayago::IntegerNode, second:)
        # Nothing to do
      end
    end
  end

  def test_single_in
    result = Kanayago.parse('alias v g')

    body = result.ast.body

    body in Kanayago::AliasNode(first:, second:)

    assert_instance_of(Kanayago::SymbolNode, first)
    assert_instance_of(Kanayago::SymbolNode, second)
  end

  def test_right_assignment
    result = Kanayago.parse('alias v g')

    body = result.ast.body

    body => Kanayago::AliasNode(first:, second:)

    assert_instance_of(Kanayago::SymbolNode, first)
    assert_instance_of(Kanayago::SymbolNode, second)
  end
end
