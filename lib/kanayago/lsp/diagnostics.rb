# frozen_string_literal: true

require 'language_server-protocol'

module Kanayago
  module LSP
    # Provides diagnostics for Ruby source code using Kanayago parser
    class DiagnosticsProvider
      def analyze(source)
        diagnostics = []

        result = Kanayago.parse(source)

        if result.invalid?
          # Extract error information from SyntaxError
          error = result.error
          diagnostic = create_diagnostic(error, result.script_lines)
          diagnostics << diagnostic
        end

        diagnostics
      end

      private

      def create_diagnostic(error, script_lines)
        # Try to extract line and column from error message
        # SyntaxError message format: "syntax error, unexpected ..."
        # or with location: "(eval):2: syntax error, unexpected ..."
        range = extract_range_from_error(error, script_lines)

        {
          range: range,
          severity: LanguageServer::Protocol::Constant::DiagnosticSeverity::ERROR,
          source: 'Kanayago',
          message: error.message.sub(/main:\d+:\s*/, '')
        }
      end

      def extract_range_from_error(error, script_lines)
        # Try to extract line number from error message
        # Format: "main:LINE: message" or "(eval):LINE: message" or just "message"
        message = error.message

        if message =~ /(?:main|\(eval\)):(\d+):/
          line = ::Regexp.last_match(1).to_i # Already 0-based or use as-is

          end_character = script_lines[line].chomp.length

          {
            start: { line: line, character: 0 },
            end: { line: line, character: end_character }
          }
        else
          # Default to line 0 if we can't extract line number
          end_character = script_lines[0].chomp.length

          {
            start: { line: 0, character: 0 },
            end: { line: 0, character: end_character }
          }
        end
      end
    end
  end
end
