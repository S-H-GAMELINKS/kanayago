# frozen_string_literal: true

require 'test_helper'

class ParseClassTest < Minitest::Test
  def test_parse_class
    result = Mjollnir.parse(<<~CODE)
      class Mjollnir
      end
    CODE

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_CLASS' => {
            'cpath' => {
              'NODE_COLON2' => {
                'mid' => :Mjollnir,
                'head' => nil
              }
            },
            'super' => nil,
            'body' => {
              'NODE_SCOPE' => {
                'args' => nil,
                'body' => {
                  'NODE_BEGIN' => {
                    'body' => nil
                  }
                }
              }
            }
          }
        }
      }
    }

    assert_equal expected, result
  end
end
