# frozen_string_literal: true

module Kanayago
  class ScopeNode
    attr_reader :args, :body
  end

  class BlockNode # rubocop:disable Lint/EmptyClass
  end

  class ArgumentsNode
    attr_reader :ainfo
  end
end
