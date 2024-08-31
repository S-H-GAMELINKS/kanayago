# frozen_string_literal: true

require 'test_helper'

class ParseConstTest < Minitest::Test
  def test_parse_const
    result = RefineTree.parse('Class')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_CONST => {
            :vid => :Class
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_const_ref
    result = RefineTree.parse(<<~CODE)
      S = 117
      p S
    CODE

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_BLOCK => [
            {
              :NODE_CDECL => {
                :vid => :S,
                :else => nil,
                :value => {
                  :NODE_INTEGER => 117
                }
              }
            },
            {
              :NODE_FCALL => {
                :mid => :p,
                :args => {
                  :NODE_LIST => [
                    :NODE_CONST => {
                      :vid => :S
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
