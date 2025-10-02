# frozen_string_literal: true

module Kanayago
  class IntegerNode
    attr_reader :val, :minus, :base
  end

  class FloatNode
    attr_reader :val, :minus
  end

  class RationalNode
    attr_reader :val, :minus, :base, :seen_point
  end

  class ImaginaryNode
    attr_reader :val, :minus, :base, :seen_point, :type
  end

  class StringNode
    attr_reader :ptr, :len, :enc, :coderange
  end

  class SymbolNode
    attr_reader :ptr, :len, :enc, :coderange
  end

  class ListNode
    attr_reader :len, :val
  end

  class ZeroListNode
    attr_reader :len, :val
  end

  class FileNode
    attr_reader :ptr, :len, :enc, :coderange
  end

  class LineNode
    attr_reader :lineno
  end

  class EncodingNode
    attr_reader :val
  end

  class NilNode
    attr_reader :val
  end

  class TrueNode
    attr_reader :val
  end

  class FalseNode
    attr_reader :val
  end

  class RangeNode
    attr_reader :beg, :end
  end

  class ExclusiveRangeNode
    attr_reader :beg, :end
  end

  class FlipFlopNode
    attr_reader :beg, :end
  end

  class ExclusiveFlipFlopNode
    attr_reader :beg, :end
  end
end
