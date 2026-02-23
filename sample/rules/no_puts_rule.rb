# frozen_string_literal: true

require_relative 'traversal'

module LintRules
  class NoPutsRule
    def check(ast:, source:, path:)
      offenses = []

      Traversal.walk(ast) do |node|
        next unless node.is_a?(Kanayago::FunctionCallNode)
        next unless node.respond_to?(:mid) && node.mid == :puts

        offenses << { message: 'Avoid using puts in application code' }
      end

      offenses
    end
  end
end
