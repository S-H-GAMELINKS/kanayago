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

  def test_parse_result_script_lines_with_single_line
    result = Kanayago.parse('x = 1')

    assert_instance_of(Array, result.script_lines)
    assert_equal(['x = 1'], result.script_lines)
  end

  def test_parse_result_script_lines_with_multiple_lines
    code = <<~RUBY
      class Foo
        def bar
          puts 'hello'
        end
      end
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(Array, result.script_lines)
    assert_equal(5, result.script_lines.length)
    assert_equal("class Foo\n", result.script_lines[0])
    assert_equal("  def bar\n", result.script_lines[1])
    assert_equal("    puts 'hello'\n", result.script_lines[2])
    assert_equal("  end\n", result.script_lines[3])
    assert_equal("end\n", result.script_lines[4])
  end

  def test_parse_result_script_lines_with_syntax_error
    code = <<~RUBY
      def foo
        x = 1 +
      end
    RUBY

    result = Kanayago.parse(code)

    # script_lines should be available even with syntax errors
    assert_instance_of(Array, result.script_lines)
    assert_equal(3, result.script_lines.length)
    assert_equal("def foo\n", result.script_lines[0])
    assert_equal("  x = 1 +\n", result.script_lines[1])
    assert_equal("end\n", result.script_lines[2])
  end

  def test_parse_result_script_lines_line_length
    code = <<~RUBY
      class Foo
        def bar
          puts 'hello world'
        end
      end
    RUBY

    result = Kanayago.parse(code)

    # Test that we can use script_lines to get line length
    assert_equal(9, result.script_lines[0].chomp.length) # "class Foo"
    assert_equal(9, result.script_lines[1].chomp.length) # "  def bar"
    assert_equal(22, result.script_lines[2].chomp.length) # "    puts 'hello world'"
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      1 + 1
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::OperatorCallNode
      assert_instance_of(Kanayago::OperatorCallNode, body)
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

    body in Kanayago::OperatorCallNode

    assert_instance_of(Kanayago::OperatorCallNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::OperatorCallNode

    assert_instance_of(Kanayago::OperatorCallNode, body)
  end
end
