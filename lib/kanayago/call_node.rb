# frozen_string_literal: true

module Kanayago
  class OperatorCallNode
    node_attributes :recv, :mid, :args
  end

  class CallNode
    node_attributes :recv, :mid, :args
  end

  class FunctionCallNode
    node_attributes :mid, :args
  end

  class VariableCallNode
    node_attributes :mid
  end
end
