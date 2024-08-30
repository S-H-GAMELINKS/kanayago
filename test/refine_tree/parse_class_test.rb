# frozen_string_literal: true

require 'test_helper'

class ParseClassTest < Minitest::Test
  def test_parse_class
    result = RefineTree.parse(<<~CODE)
      class RefineTree
      end
    CODE

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_CLASS' => {
            'cpath' => {
              'NODE_COLON2' => {
                'mid' => :RefineTree,
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
