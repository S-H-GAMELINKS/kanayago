# frozen_string_literal: true

class ParseStringTest < Minitest::Test
  def test_parse_string
    result = Mjollnir.parse('"Mjollnir"')

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_STR' => 'Mjollnir'
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_string_plus_opcall
    result = Mjollnir.parse('"Mjollnir" + ".parse"')

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_OPCALL' => {
            'recv' => {
              'NODE_STR' => 'Mjollnir'
            },
            'mid' => :+,
            'args' => {
              'NODE_LIST' => [
                'NODE_STR' => '.parse'
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_string_times_opcall
    result = Mjollnir.parse('"Mjollnir" * 2')

    expected = {
      'NODE_SCOPE' => {
        'args' => nil,
        'body' => {
          'NODE_OPCALL' => {
            'recv' => {
              'NODE_STR' => 'Mjollnir'
            },
            'mid' => :*,
            'args' => {
              'NODE_LIST' => [
                {
                  'NODE_INTEGER' => 2
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
