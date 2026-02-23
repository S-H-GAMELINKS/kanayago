# frozen_string_literal: true

module Kanayago
  class LocalVariableNode
    node_attributes :vid
  end

  class DynamicVariableNode
    node_attributes :vid
  end

  class InstanceVariableNode
    node_attributes :vid
  end

  class ClassVariableNode
    node_attributes :vid
  end

  class GlobalVariableNode
    node_attributes :vid
  end

  class ConstantNode
    node_attributes :vid
  end
end
