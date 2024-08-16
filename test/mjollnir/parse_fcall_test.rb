# frozen_string_literal: true

require 'test_helper'

class ParseFcallTest < Minitest::Test
  def test_parse_fcall
    result = Mjollnir.parse('p 117')

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_FCALL' => {
            'mid' => :p,
            'args' => {
              'NODE_LIST' => [
                {
                  'NODE_INTEGER' => 117
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end
end
