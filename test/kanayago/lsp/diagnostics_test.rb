# frozen_string_literal: true

require_relative '../../test_helper'

class DiagnosticsTest < Minitest::Test
  def setup
    @provider = Kanayago::LSP::DiagnosticsProvider.new
  end

  def test_no_diagnostics_for_valid_code
    source = 'def foo; end'
    diagnostics = @provider.analyze(source)

    assert_empty diagnostics
  end

  def test_diagnostics_for_syntax_error
    source = 'def foo'
    diagnostics = @provider.analyze(source)

    assert_equal 1, diagnostics.length

    diagnostic = diagnostics.first

    assert_equal LanguageServer::Protocol::Constant::DiagnosticSeverity::ERROR,
                 diagnostic[:severity]
    assert_equal 'Kanayago', diagnostic[:source]
    assert_match(/syntax error/, diagnostic[:message])
  end

  def test_diagnostics_for_incomplete_class
    source = 'class Foo'
    diagnostics = @provider.analyze(source)

    refute_empty diagnostics
  end

  def test_diagnostics_for_complex_error
    source = <<~RUBY
      class Foo
        def bar
          if condition
        end
      end
    RUBY

    diagnostics = @provider.analyze(source)

    refute_empty diagnostics
  end

  def test_diagnostics_for_complex_valid_code
    source = <<~RUBY
      class MyClass
        def initialize(name)
          @name = name
        end

        def greet
          puts "Hello, \#{@name}!"
        end
      end
    RUBY

    diagnostics = @provider.analyze(source)

    assert_empty diagnostics
  end

  def test_diagnostic_range_extraction
    source = 'def foo'
    diagnostics = @provider.analyze(source)

    assert_equal 1, diagnostics.length

    diagnostic = diagnostics.first

    assert diagnostic[:range]
    assert diagnostic[:range][:start]
    assert diagnostic[:range][:end]
    assert_kind_of Integer, diagnostic[:range][:start][:line]
    assert_kind_of Integer, diagnostic[:range][:start][:character]
  end
end
