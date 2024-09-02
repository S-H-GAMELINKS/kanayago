# frozen_string_literal: true

class ParseImaginaryTest < Minitest::Test
  def test_parse_imaginary
    result = Kanayago.parse('117i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_IMAGINARY: 0 + 117i
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_plus_opcall
    result = Kanayago.parse('117i + 117i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_IMAGINARY: 0 + 117i
            },
            mid: :+,
            args: {
              NODE_LIST: [
                {
                  NODE_IMAGINARY: 0 + 117i
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_minus_opcall
    result = Kanayago.parse('117i - 117i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_IMAGINARY: 0 + 117i
            },
            mid: :-,
            args: {
              NODE_LIST: [
                {
                  NODE_IMAGINARY: 0 + 117i
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_times_opcall
    result = Kanayago.parse('117i * 117i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_IMAGINARY: 0 + 117i
            },
            mid: :*,
            args: {
              NODE_LIST: [
                {
                  NODE_IMAGINARY: 0 + 117i
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_div_opcall
    result = Kanayago.parse('117i / 117i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_IMAGINARY: 0 + 117i
            },
            mid: :/,
            args: {
              NODE_LIST: [
                {
                  NODE_IMAGINARY: 0 + 117i
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_remainder_opcall
    result = Kanayago.parse('117i % 117i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_IMAGINARY: 0 + 117i
            },
            mid: :%,
            args: {
              NODE_LIST: [
                {
                  NODE_IMAGINARY: 0 + 117i
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_call
    result = Kanayago.parse('117i.to_i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_CALL: {
            recv: {
              NODE_IMAGINARY: 0 + 117i
            },
            mid: :to_i,
            args: nil
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_imaginary_call_with_arg; end
end
