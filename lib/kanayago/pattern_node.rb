# frozen_string_literal: true

module Kanayago
  class InNode
    node_attributes :head, :body, :next
  end

  class ArrayPatternNode
    node_attributes :pconst, :pre_args, :rest_arg, :post_args
  end

  class HashPatternNode
    node_attributes :pconst, :pkwargs, :pkwrestarg
  end

  class FindPatternNode
    node_attributes :pconst, :pre_rest_arg, :args, :post_rest_arg
  end
end
