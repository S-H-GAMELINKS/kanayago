# frozen_string_literal: true

module Kanayago
  class OperatorCallNode
    attr_reader :recv, :mid, :args
  end

  class CallNode
    attr_reader :recv, :mid, :args
  end

  class FunctionCallNode
    attr_reader :mid, :args
  end

  class VariableCallNode
    attr_reader :mid
  end
end
