# frozen_string_literal: true

module Kanayago
  class ConstantDeclarationNode
    node_attributes :vid, :else, :value
  end

  class Colon2Node
    node_attributes :mid, :head
  end

  class Colon3Node
    node_attributes :mid
  end
end
