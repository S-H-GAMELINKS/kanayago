# frozen_string_literal: true

require_relative '../test_helper'

class ParseLasgnTest < Minitest::Test
  def test_parse_lasgn
    result = Kanayago.parse('var = 117')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_LASGN: {
            id: :var,
            value: {
              NODE_INTEGER: 117
            }
          }
        }
      }
    }

    assert_equal expected, result
  end
end
