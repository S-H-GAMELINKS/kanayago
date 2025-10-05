# frozen_string_literal: true

module Kanayago
  class InNode
    attr_reader :head, :body, :next
  end

  class ArrayPatternNode
    attr_reader :pconst, :pre_args, :rest_arg, :post_args
  end

  class HashPatternNode
    attr_reader :pconst, :pkwargs, :pkwrestarg
  end

  class FindPatternNode
    attr_reader :pconst, :pre_rest_arg, :args, :post_rest_arg
  end
end
