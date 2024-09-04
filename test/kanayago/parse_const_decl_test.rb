# frozen_string_literal: true

require_relative '../test_helper'

class ParseConstDeclTest < Minitest::Test
  def test_parse_const_decl
    result = Kanayago.parse('S = 117')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_CDECL: {
            vid: :S,
            else: nil,
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
