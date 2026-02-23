# frozen_string_literal: true

module Kanayago
  class IntegerNode < BaseNode
    node_attributes :val, :minus, :base
  end

  class FloatNode
    node_attributes :val, :minus
  end

  class RationalNode
    node_attributes :val, :minus, :base, :seen_point
  end

  class ImaginaryNode
    node_attributes :val, :minus, :base, :seen_point, :type
  end

  class StringNode
    node_attributes :ptr, :len, :enc, :coderange
  end

  class SymbolNode
    node_attributes :ptr, :len, :enc, :coderange
  end

  class ListNode
    node_attributes :len, :val
  end

  class ZeroListNode
    node_attributes :len, :val
  end

  class FileNode
    node_attributes :ptr, :len, :enc, :coderange
  end

  class LineNode
    node_attributes :lineno
  end

  class EncodingNode
    node_attributes :val
  end

  class NilNode
    node_attributes :val
  end

  class TrueNode
    node_attributes :val
  end

  class FalseNode
    node_attributes :val
  end

  class RangeNode
    node_attributes :beg, :end
  end

  class ExclusiveRangeNode
    node_attributes :beg, :end
  end

  class FlipFlopNode
    node_attributes :beg, :end
  end

  class ExclusiveFlipFlopNode
    node_attributes :beg, :end
  end

  class HashNode
    node_attributes :head, :brace
  end

  class NthRefNode
    node_attributes :nth
  end

  class BackRefNode
    node_attributes :nth
  end

  class SelfNode
    node_attributes :state
  end
end
