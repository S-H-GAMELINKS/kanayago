# frozen_string_literal: true

require_relative 'traversal'

module LintRules
  class NoPCallRule
    def check(ast:, source:, path:)
      offenses = []

      Traversal.walk(ast) do |node|
        next unless node.is_a?(Kanayago::FunctionCallNode)
        next unless node.respond_to?(:mid) && node.mid == :p

        offenses << { message: 'Avoid using p for debug output' }
      end

      offenses
    end
  end
end
