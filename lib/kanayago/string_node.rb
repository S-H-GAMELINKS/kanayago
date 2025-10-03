# frozen_string_literal: true

module Kanayago
  class DynamicStringNode
    attr_reader :string, :next_nodes
  end

  class EmbeddedExpressionStringNode
    attr_reader :body
  end

  class ExecuteStringNode
    attr_reader :ptr, :len, :enc, :coderange
  end

  class DynamicExecuteStringNode
    attr_reader :string, :next_nodes
  end
end
