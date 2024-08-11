require "test_helper"

class ParseIntegerTest < Minitest::Test
  def test_parse_integer
    result = Mjollnir.parse('1')

    expected = {
      "NODE_SCOPE" => {
        "NODE_INTEGER" => 1
      }
    }

    assert_equal expected, result
  end
end

