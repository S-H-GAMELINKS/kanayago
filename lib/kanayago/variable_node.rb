# frozen_string_literal: true

module Kanayago
  class LocalVariableNode
    attr_reader :vid
  end

  class DynamicVariableNode
    attr_reader :vid
  end

  class InstanceVariableNode
    attr_reader :vid
  end

  class ClassVariableNode
    attr_reader :vid
  end

  class GlobalVariableNode
    attr_reader :vid
  end

  class ConstantNode
    attr_reader :vid
  end
end
