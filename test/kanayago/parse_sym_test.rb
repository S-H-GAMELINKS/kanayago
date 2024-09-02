# frozen_string_literal: true

require 'test_helper'

class ParseSymTest < Minitest::Test
  def test_parse_sym
    result = Kanayago.parse(':kanayago')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_SYM => :kanayago
        }
      }
    }

    assert_equal expected, result
  end
end
