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
          diagnostic = create_diagnostic(error)
          diagnostics << diagnostic
        end

        diagnostics
      end

      private

      def create_diagnostic(error)
        # Try to extract line and column from error message
        # SyntaxError message format: "syntax error, unexpected ..."
        # or with location: "(eval):2: syntax error, unexpected ..."
        range = extract_range_from_error(error)

        {
          range: range,
          severity: LanguageServer::Protocol::Constant::DiagnosticSeverity::ERROR,
          source: 'Kanayago',
          message: error.message
        }
      end

      def extract_range_from_error(error)
        # Try to extract line number from error message
        # Format: "(eval):LINE: message" or just "message"
        message = error.message

        if message =~ /\(eval\):(\d+):/
          line = ::Regexp.last_match(1).to_i - 1 # Convert to 0-based
          {
            start: { line: line, character: 0 },
            end: { line: line, character: 0 }
          }
        else
          # Default to line 0 if we can't extract line number
          {
            start: { line: 0, character: 0 },
            end: { line: 0, character: 0 }
          }
        end
      end
    end
  end
end
