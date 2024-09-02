# frozen_string_literal: true

require 'test_helper'

class ParseIvarTest < Minitest::Test
  def test_parse_ivar
    result = Kanayago.parse('@kanayago')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_IVAR => {
            :vid => :@kanayago
          }
        }
      }
    }

    assert_equal expected, result
  end
end
