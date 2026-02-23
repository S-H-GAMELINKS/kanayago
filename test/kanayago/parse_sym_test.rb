# frozen_string_literal: true

require_relative '../test_helper'

class ParseSymTest < Minitest::Test
  def test_parse_sym
    result = Kanayago.parse(':kanayago')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::SymbolNode, body)
    assert_equal('kanayago', body.ptr)
    assert_equal(8, body.len)
    assert_equal(Encoding::US_ASCII, body.enc)
    assert_equal('RB_PARSER_ENC_CODERANGE_UNKNOWN', body.coderange)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      :kanayago
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::SymbolNode
      assert_instance_of(Kanayago::SymbolNode, body)
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

    body in Kanayago::SymbolNode

    assert_instance_of(Kanayago::SymbolNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::SymbolNode

    assert_instance_of(Kanayago::SymbolNode, body)
  end
end
