# frozen_string_literal: true

require_relative '../test_helper'

class ParseResultTest < Minitest::Test
  def test_parse_result_with_valid_code
    result = Kanayago.parse('1 + 1')

    assert_instance_of(Kanayago::ParseResult, result)
    assert_predicate(result, :valid?)
    refute_predicate(result, :invalid?)
    assert_instance_of(Kanayago::ScopeNode, result.ast)
    refute_kind_of(SyntaxError, result.error)
  end

  def test_parse_result_with_syntax_error
    code = <<~RUBY
      def foo
        x = 1 +
      end
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ParseResult, result)
    refute_predicate(result, :valid?)
    assert_predicate(result, :invalid?)
    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_instance_of(SyntaxError, result.error)
  end

  def test_parse_result_error_message
    code = <<~RUBY
      def foo
        x = 1 +
      end
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(SyntaxError, result.error)
    assert_match(/syntax error/, result.error.message)
    assert_match(/unexpected 'end'/, result.error.message)
  end

  def test_parse_result_ast_accessor
    result = Kanayago.parse('x = 1')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)
    assert_instance_of(Kanayago::LocalAssignmentNode, result.ast.body)
  end

  def test_parse_result_error_accessor_with_valid_code
    result = Kanayago.parse('x = 1')

    # Valid code should not have SyntaxError
    refute_kind_of(SyntaxError, result.error)
  end

  def test_parse_result_with_multiple_syntax_errors
    code = <<~RUBY
      def foo
        x = 1 +
        y = 2 *
      end
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ParseResult, result)
    assert_predicate(result, :invalid?)
    assert_instance_of(SyntaxError, result.error)
    # First error should be reported
    assert_match(/syntax error/, result.error.message)
  end

  def test_parse_result_with_unclosed_string
    code = '"unclosed string'

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ParseResult, result)
    assert_predicate(result, :invalid?)
    assert_instance_of(SyntaxError, result.error)
    assert_match(/unterminated string/, result.error.message)
  end

  def test_parse_result_with_unexpected_token
    code = 'def foo end end'

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ParseResult, result)
    assert_predicate(result, :invalid?)
    assert_instance_of(SyntaxError, result.error)
    assert_match(/syntax error/, result.error.message)
  end

  def test_parse_result_valid_method_with_simple_expression
    result = Kanayago.parse('1')

    assert_predicate(result, :valid?)
    assert_instance_of(Kanayago::IntegerNode, result.ast.body)
  end

  def test_parse_result_invalid_method_with_missing_expression
    code = <<~RUBY
      if
      end
    RUBY

    result = Kanayago.parse(code)

    assert_predicate(result, :invalid?)
    assert_instance_of(SyntaxError, result.error)
  end

  def test_parse_result_with_empty_code
    result = Kanayago.parse('')

    assert_instance_of(Kanayago::ParseResult, result)
    assert_predicate(result, :valid?)
    assert_instance_of(Kanayago::ScopeNode, result.ast)
  end
end
