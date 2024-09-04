# frozen_string_literal: true

require_relative '../test_helper'

class ParseDefnTest < Minitest::Test
  def test_parse_defn
    result = Kanayago.parse(<<~CODE)
      def kanayago
        p 117
      end
    CODE

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_DEFN: {
            mid: :kanayago,
            defn: {
              NODE_SCOPE: {
                args: {
                  NODE_ARGS: {
                    ainfo: {
                      forwarding: 0,
                      pre_args_num: 0,
                      pre_init: nil,
                      post_args_num: 0,
                      post_init: nil,
                      first_post_arg: nil,
                      rest_arg: nil,
                      block_arg: nil,
                      opt_args: nil,
                      kw_args: nil,
                      kw_rest_arg: nil
                    }
                  }
                },
                body: {
                  NODE_FCALL: {
                    mid: :p,
                    args: {
                      NODE_LIST: [
                        {
                          NODE_INTEGER: 117
                        }
                      ]
                    }
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
