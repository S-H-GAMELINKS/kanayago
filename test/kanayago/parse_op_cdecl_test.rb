# frozen_string_literal: true

require_relative '../test_helper'

class ParseOpCdeclTest < Minitest::Test
  def test_parse_op_cdecl_plus
    result = Kanayago.parse('Foo::CONST += 100')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
    assert_equal(:+, body.aid)
    assert_instance_of(Kanayago::Colon2Node, body.head)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end

  def test_parse_op_cdecl_multiply
    result = Kanayago.parse('Bar::MAX_VALUE *= 2')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
    assert_equal(:*, body.aid)
  end

  def test_parse_op_cdecl_scoped
    result = Kanayago.parse('Foo::Bar::CONST += 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      Foo::CONST += 100
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::OperatorConstantDeclarationNode
      assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
    end
  end

  def test_case_in_unmatched
    body = pattern_match_target_body

    assert_raises(NoMatchingPatternError) do
      case body.class.name
      in '__kanayago_unmatched_pattern__'
        # Nothing to do
      end
    end
  end

  def test_single_in
    body = pattern_match_target_body

    body in Kanayago::OperatorConstantDeclarationNode

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::OperatorConstantDeclarationNode

    assert_instance_of(Kanayago::OperatorConstantDeclarationNode, body)
  end
end
