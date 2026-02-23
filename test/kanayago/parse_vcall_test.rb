# frozen_string_literal: true

require_relative '../test_helper'

class ParseVcallTest < Minitest::Test
  def test_parse_vcall
    result = Kanayago.parse('foo')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::VariableCallNode, body)
    assert_equal(:foo, body.mid)
  end

  def test_parse_vcall_with_underscore
    result = Kanayago.parse('foo_bar')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::VariableCallNode, body)
    assert_equal(:foo_bar, body.mid)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      foo
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::VariableCallNode
      assert_instance_of(Kanayago::VariableCallNode, body)
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

    body in Kanayago::VariableCallNode

    assert_instance_of(Kanayago::VariableCallNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::VariableCallNode

    assert_instance_of(Kanayago::VariableCallNode, body)
  end
end
