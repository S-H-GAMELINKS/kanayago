# frozen_string_literal: true

module Kanayago
  class IfStatementNode
    node_attributes :cond, :body, :else
  end

  class UnlessStatementNode
    node_attributes :cond, :body, :else
  end

  class OrNode
    node_attributes :first, :second
  end

  class AndNode
    node_attributes :first, :second
  end

  class WhileNode
    node_attributes :state, :cond, :body
  end

  class UntilNode
    node_attributes :state, :cond, :body
  end

  class ForNode
    node_attributes :iter, :body
  end

  class AliasNode
    node_attributes :first, :second
  end

  class ValiasNode
    node_attributes :alias, :original
  end

  class UndefNode
    node_attributes :undefs
  end

  class ReturnNode
    node_attributes :statements
  end

  class GlobalAssignmentNode
    node_attributes :id, :value
  end

  class ClassVariableAssignmentNode
    node_attributes :id, :value
  end

  class InstanceAssignmentNode
    node_attributes :id, :value
  end

  class LocalAssignmentNode
    node_attributes :id, :value
  end

  class DefinitionNode
    node_attributes :mid, :defn
  end

  class SingletonDefinitionNode
    node_attributes :recv, :mid, :defn
  end

  class ClassNode
    node_attributes :cpath, :super, :body
  end

  class ModuleNode
    node_attributes :cpath, :body
  end

  class SingletonClassNode
    node_attributes :recv, :body
  end

  class AttributeAssignmentNode
    node_attributes :recv, :mid, :args
  end

  class SafeCallNode
    node_attributes :recv, :mid, :args
  end

  class SuperNode
    node_attributes :args
  end

  class ZeroSuperNode # rubocop:disable Lint/EmptyClass
  end

  class CaseNode
    node_attributes :head, :body
  end

  class Case2Node
    node_attributes :body
  end

  class Case3Node
    node_attributes :head, :body
  end

  class WhenNode
    node_attributes :head, :body, :next
  end

  class RetryNode # rubocop:disable Lint/EmptyClass
  end

  class RedoNode # rubocop:disable Lint/EmptyClass
  end

  class BreakNode
    node_attributes :statements
  end

  class NextNode
    node_attributes :statements
  end

  class DefinedNode
    node_attributes :head
  end

  class IterNode
    node_attributes :body, :iter
  end

  class BeginNode
    node_attributes :body
  end

  class EnsureNode
    node_attributes :head, :ensr
  end

  class RescueNode
    node_attributes :head, :resq, :else
  end

  class RescueBodyNode
    node_attributes :args, :exc_var, :body, :next
  end

  class OperatorAssignment1Node
    node_attributes :recv, :mid, :index, :rvalue
  end

  class OperatorAssignment2Node
    node_attributes :recv, :value, :vid, :mid
  end

  class OperatorAssignmentAndNode
    node_attributes :head, :value
  end

  class OperatorAssignmentOrNode
    node_attributes :head, :value
  end

  class OperatorConstantDeclarationNode
    node_attributes :head, :value, :aid, :shareability
  end

  class YieldNode
    node_attributes :head
  end

  class LambdaNode
    node_attributes :body
  end

  class SplatNode
    node_attributes :head
  end

  class BlockPassNode
    node_attributes :head, :body, :forwarding
  end

  class ArgsAuxNode
    node_attributes :pid, :plen, :next
  end

  class OptArgNode
    node_attributes :body, :next
  end

  class KwArgNode
    node_attributes :body, :next
  end

  class PostArgNode
    node_attributes :first, :second
  end

  class ArgsCatNode
    node_attributes :head, :body
  end

  class ArgsPushNode
    node_attributes :head, :body
  end

  class ForMasgnNode
    node_attributes :var
  end

  class MasgnNode
    node_attributes :head, :value, :args
  end

  class DasgnNode
    node_attributes :vid, :value
  end

  class OnceNode
    node_attributes :body
  end

  class ErrinfoNode # rubocop:disable Lint/EmptyClass
  end

  class PostexeNode
    node_attributes :body
  end

  class ErrorNode # rubocop:disable Lint/EmptyClass
  end
end
