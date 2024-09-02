# frozen_string_literal: true

class ParseStringTest < Minitest::Test
  def test_parse_string
    result = Kanayago.parse('"Kanayago"')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_STR: 'Kanayago'
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_string_plus_opcall
    result = Kanayago.parse('"Kanayago" + ".parse"')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_STR: 'Kanayago'
            },
            mid: :+,
            args: {
              NODE_LIST: [
                NODE_STR: '.parse'
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_string_times_opcall
    result = Kanayago.parse('"Kanayago" * 2')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_STR: 'Kanayago'
            },
            mid: :*,
            args: {
              NODE_LIST: [
                {
                  NODE_INTEGER: 2
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
