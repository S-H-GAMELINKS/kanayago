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
end
