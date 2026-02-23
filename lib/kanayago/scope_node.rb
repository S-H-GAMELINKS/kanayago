# frozen_string_literal: true

module Kanayago
  class ScopeNode
    node_attributes :args, :body
  end

  class BlockNode # rubocop:disable Lint/EmptyClass
  end

  class ArgumentsNode
    node_attributes :ainfo
  end
end
