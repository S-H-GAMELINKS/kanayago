# frozen_string_literal: true

class ParseImaginaryTest < Minitest::Test
  def test_parse_imaginary
    result = Mjollnir.parse('117i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_IMAGINARY' => 0 + 117i
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_plus_opcall
    result = Mjollnir.parse('117i + 117i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_IMAGINARY' => 0 + 117i
          },
          'mid' => :+,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_IMAGINARY' => 0 + 117i
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_minus_opcall
    result = Mjollnir.parse('117i - 117i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_IMAGINARY' => 0 + 117i
          },
          'mid' => :-,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_IMAGINARY' => 0 + 117i
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_times_opcall
    result = Mjollnir.parse('117i * 117i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_IMAGINARY' => 0 + 117i
          },
          'mid' => :*,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_IMAGINARY' => 0 + 117i
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_div_opcall
    result = Mjollnir.parse('117i / 117i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_IMAGINARY' => 0 + 117i
          },
          'mid' => :/,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_IMAGINARY' => 0 + 117i
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_remainder_opcall
    result = Mjollnir.parse('117i % 117i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_IMAGINARY' => 0 + 117i
          },
          'mid' => :%,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_IMAGINARY' => 0 + 117i
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_call
    result = Mjollnir.parse('117i.to_i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_CALL' => {
          'recv' => {
            'NODE_IMAGINARY' => 0 + 117i
          },
          'mid' => :to_i,
          'args' => nil
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_call_with_arg; end
end
