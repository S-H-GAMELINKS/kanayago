# frozen_string_literal: true

require 'test_helper'

class ParseConstTest < Minitest::Test
  def test_parse_const
    result = Mjollnir.parse('Class')

    expected = {
      'NODE_SCOPE' => {
        'NODE_CONST' => {
          'vid' => :Class
        }
      }
    }

    assert_equal expected, result
  end
end
