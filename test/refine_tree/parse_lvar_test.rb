# frozen_string_literal: true

require 'test_helper'

class ParseLvarTest < Minitest::Test
  def test_parse_lvar
    result = RefineTree.parse(<<~CODE)
      v = 117
      p v
    CODE

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_BLOCK' => [
            {
              'NODE_LASGN' => {
                'id' => :v,
                'value' => {
                  'NODE_INTEGER' => 117
                }
              }
            },
            {
              'NODE_FCALL' => {
                'mid' => :p,
                'args' => {
                  'NODE_LIST' => [
                    {
                      'NODE_LVAR' => {
                        'vid' => :v
                      }
                    }
                  ]
                }
              }
            }
          ]
        }
      }
    }

    assert_equal expected, result
  end
end
