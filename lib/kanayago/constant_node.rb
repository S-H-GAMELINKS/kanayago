# frozen_string_literal: true

module Kanayago
  class ConstantDeclarationNode
    attr_reader :vid, :else, :value
  end

  class Colon2Node
    attr_reader :mid, :head
  end

  class Colon3Node
    attr_reader :mid
  end
end
