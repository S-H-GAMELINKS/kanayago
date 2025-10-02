# frozen_string_literal: true

module Kanayago
  class IfStatementNode
    attr_reader :cond, :body, :else
  end

  class UnlessStatementNode
    attr_reader :cond, :body, :else
  end

  class OrNode
    attr_reader :first, :second
  end

  class AndNode
    attr_reader :first, :second
  end

  class WhileNode
    attr_reader :state, :cond, :body
  end

  class UntilNode
    attr_reader :state, :cond, :body
  end

  class ForNode
    attr_reader :iter, :body
  end

  class AliasNode
    attr_reader :first, :second
  end

  class ValiasNode
    attr_reader :alias, :original
  end

  class UndefNode
    attr_reader :undefs
  end

  class ReturnNode
    attr_reader :statements
  end

  class GlobalAssignmentNode
    attr_reader :id, :value
  end

  class ClassVariableAssignmentNode
    attr_reader :id, :value
  end

  class InstanceAssignmentNode
    attr_reader :id, :value
  end

  class LocalAssignmentNode
    attr_reader :id, :value
  end

  class SingletonDefinitionNode
    attr_reader :recv, :mid, :defn
  end

  class SingletonClassNode
    attr_reader :recv, :body
  end

  class AttributeAssignmentNode
    attr_reader :recv, :mid, :args
  end

  class SafeCallNode
    attr_reader :recv, :mid, :args
  end

  class SuperNode
    attr_reader :args
  end

  class ZeroSuperNode # rubocop:disable Lint/EmptyClass
  end

  class CaseNode
    attr_reader :head, :body
  end

  class Case2Node
    attr_reader :body
  end

  class Case3Node
    attr_reader :head, :body
  end

  class WhenNode
    attr_reader :head, :body, :next
  end
end
