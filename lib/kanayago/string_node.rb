# frozen_string_literal: true

module Kanayago
  class DynamicStringNode
    attr_reader :string, :next_nodes
  end

  class DynamicSymbolNode
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

  class RegexpNode
    attr_reader :ptr, :len, :enc, :coderange, :options
  end

  class DynamicRegexpNode
    attr_reader :string, :next_nodes, :options
  end

  class MatchNode
    attr_reader :ptr, :len, :enc, :coderange, :options
  end

  class Match2Node
    attr_reader :recv, :value, :args
  end

  class Match3Node
    attr_reader :recv, :value
  end
end
