# frozen_string_literal: true

module LintRules
  module Traversal
    module_function

    def walk(node, visited = {}, &block)
      return if node.nil?

      # Guard against accidental cyclic object graphs.
      object_id = node.object_id
      return if visited[object_id]

      visited[object_id] = true
      yield node

      if node.is_a?(Array)
        node.each { |child| walk(child, visited, &block) }
        return
      end

      return unless node.respond_to?(:instance_variables)

      node.instance_variables.each do |ivar|
        child = node.instance_variable_get(ivar)
        walk(child, visited, &block)
      end
    end
  end
end
