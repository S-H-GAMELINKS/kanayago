# frozen_string_literal: true

require_relative '../test_helper'

class ParseConstDeclTest < Minitest::Test
  def test_parse_const_decl
    result = Kanayago.parse('S = 117')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::ConstantDeclarationNode, body)
    assert_equal(:S, body.vid)
    assert_nil(body.else)
    assert_instance_of(Kanayago::IntegerNode, body.value)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      S = 117
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ConstantDeclarationNode
      assert_instance_of(Kanayago::ConstantDeclarationNode, body)
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

    body in Kanayago::ConstantDeclarationNode

    assert_instance_of(Kanayago::ConstantDeclarationNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ConstantDeclarationNode

    assert_instance_of(Kanayago::ConstantDeclarationNode, body)
  end
end
