# frozen_string_literal: true

module Kanayago
  class DynamicStringNode
    node_attributes :string, :next_nodes
  end

  class DynamicSymbolNode
    node_attributes :string, :next_nodes
  end

  class EmbeddedExpressionStringNode
    node_attributes :body
  end

  class ExecuteStringNode
    node_attributes :ptr, :len, :enc, :coderange
  end

  class DynamicExecuteStringNode
    node_attributes :string, :next_nodes
  end

  class RegexpNode
    node_attributes :ptr, :len, :enc, :coderange, :options
  end

  class DynamicRegexpNode
    node_attributes :string, :next_nodes, :options
  end

  class MatchNode
    node_attributes :ptr, :len, :enc, :coderange, :options
  end

  class Match2Node
    node_attributes :recv, :value, :args
  end

  class Match3Node
    node_attributes :recv, :value
  end
end
