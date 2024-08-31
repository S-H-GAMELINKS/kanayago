# frozen_string_literal: true

require 'test_helper'

class ParseIvarTest < Minitest::Test
  def test_parse_ivar
    result = RefineTree.parse('@refine_tree')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_IVAR => {
            :vid => :@refine_tree
          }
        }
      }
    }

    assert_equal expected, result
  end
end
