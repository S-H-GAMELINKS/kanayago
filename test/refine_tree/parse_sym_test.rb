# frozen_string_literal: true

require 'test_helper'

class ParseSymTest < Minitest::Test
  def test_parse_sym
    result = RefineTree.parse(':refine_tree')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_SYM => :refine_tree
        }
      }
    }

    assert_equal expected, result
  end
end
