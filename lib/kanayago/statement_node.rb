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

  class RetryNode # rubocop:disable Lint/EmptyClass
  end

  class RedoNode # rubocop:disable Lint/EmptyClass
  end

  class BreakNode
    attr_reader :statements
  end

  class NextNode
    attr_reader :statements
  end

  class DefinedNode
    attr_reader :head
  end

  class IterNode
    attr_reader :body, :iter
  end

  class EnsureNode
    attr_reader :head, :ensr
  end

  class RescueNode
    attr_reader :head, :resq, :else
  end

  class RescueBodyNode
    attr_reader :args, :exc_var, :body, :next
  end

  class OperatorAssignment1Node
    attr_reader :recv, :mid, :index, :rvalue
  end

  class OperatorAssignment2Node
    attr_reader :recv, :value, :vid, :mid
  end

  class OperatorAssignmentAndNode
    attr_reader :head, :value
  end

  class OperatorAssignmentOrNode
    attr_reader :head, :value
  end

  class OperatorConstantDeclarationNode
    attr_reader :head, :value, :aid, :shareability
  end

  class YieldNode
    attr_reader :head
  end

  class LambdaNode
    attr_reader :body
  end

  class SplatNode
    attr_reader :head
  end

  class BlockPassNode
    attr_reader :head, :body, :forwarding
  end

  class ArgsAuxNode
    attr_reader :pid, :plen, :next
  end

  class OptArgNode
    attr_reader :body, :next
  end

  class KwArgNode
    attr_reader :body, :next
  end

  class PostArgNode
    attr_reader :first, :second
  end

  class ArgsCatNode
    attr_reader :head, :body
  end

  class ArgsPushNode
    attr_reader :head, :body
  end

  class ForMasgnNode
    attr_reader :var
  end

  class MasgnNode
    attr_reader :head, :value, :args
  end

  class DasgnNode
    attr_reader :vid, :value
  end

  class OnceNode
    attr_reader :body
  end

  class ErrinfoNode # rubocop:disable Lint/EmptyClass
  end

  class PostexeNode
    attr_reader :body
  end

  class ErrorNode # rubocop:disable Lint/EmptyClass
  end
end
