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
end
