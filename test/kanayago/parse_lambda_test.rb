# frozen_string_literal: true

require_relative '../test_helper'

class ParseLambdaTest < Minitest::Test
  def test_parse_lambda_no_args
    result = Kanayago.parse('-> { 42 }')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::LambdaNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_parse_lambda_with_args
    result = Kanayago.parse('->(x) { x * 2 }')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::LambdaNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_parse_lambda_multiline
    code = <<~RUBY
      ->(x, y) {
        x + y
      }
    RUBY
    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::LambdaNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_parse_lambda_do_end
    code = 'lambda do |x| x * 2 end'
    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      -> { 42 }
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::LambdaNode
      assert_instance_of(Kanayago::LambdaNode, body)
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

    body in Kanayago::LambdaNode

    assert_instance_of(Kanayago::LambdaNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::LambdaNode

    assert_instance_of(Kanayago::LambdaNode, body)
  end
end
