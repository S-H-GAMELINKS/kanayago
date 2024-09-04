# frozen_string_literal: true

require_relative '../test_helper'

class ParseRationalTest < Minitest::Test
  def test_parse_rational
    result = Kanayago.parse('1/17r')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_INTEGER: 1
            },
            mid: :/,
            args: {
              NODE_LIST: [
                {
                  NODE_RATIONAL: 17
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_plus_opcall
    result = Kanayago.parse('1/17r + 1/17r')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_OPCALL: {
                recv: {
                  NODE_INTEGER: 1
                },
                mid: :/,
                args: {
                  NODE_LIST: [
                    {
                      NODE_RATIONAL: 17
                    }
                  ]
                }
              }
            },
            mid: :+,
            args: {
              NODE_LIST: [
                {
                  NODE_OPCALL: {
                    recv: {
                      NODE_INTEGER: 1
                    },
                    mid: :/,
                    args: {
                      NODE_LIST: [
                        {
                          NODE_RATIONAL: 17
                        }
                      ]
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_minus_opcall
    result = Kanayago.parse('1/17r - 1/17r')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_OPCALL: {
                recv: {
                  NODE_INTEGER: 1
                },
                mid: :/,
                args: {
                  NODE_LIST: [
                    {
                      NODE_RATIONAL: 17
                    }
                  ]
                }
              }
            },
            mid: :-,
            args: {
              NODE_LIST: [
                {
                  NODE_OPCALL: {
                    recv: {
                      NODE_INTEGER: 1
                    },
                    mid: :/,
                    args: {
                      NODE_LIST: [
                        {
                          NODE_RATIONAL: 17
                        }
                      ]
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_times_opcall
    result = Kanayago.parse('1/17r * 1/17r')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_OPCALL: {
                recv: {
                  NODE_OPCALL: {
                    recv: {
                      NODE_INTEGER: 1
                    },
                    mid: :/,
                    args: {
                      NODE_LIST: [
                        NODE_RATIONAL: 17
                      ]
                    }
                  }
                },
                mid: :*,
                args: {
                  NODE_LIST: [
                    {
                      NODE_INTEGER: 1
                    }
                  ]
                }
              }
            },
            mid: :/,
            args: {
              NODE_LIST: [
                NODE_RATIONAL: 17
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_div_opcall
    result = Kanayago.parse('1/17r / 1/17r')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_OPCALL: {
                recv: {
                  NODE_OPCALL: {
                    recv: {
                      NODE_INTEGER: 1
                    },
                    mid: :/,
                    args: {
                      NODE_LIST: [
                        NODE_RATIONAL: 17
                      ]
                    }
                  }
                },
                mid: :/,
                args: {
                  NODE_LIST: [
                    {
                      NODE_INTEGER: 1
                    }
                  ]
                }
              }
            },
            mid: :/,
            args: {
              NODE_LIST: [
                NODE_RATIONAL: 17
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_remainder_opcall
    result = Kanayago.parse('1/17r % 1/17r')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_OPCALL: {
                recv: {
                  NODE_OPCALL: {
                    recv: {
                      NODE_INTEGER: 1
                    },
                    mid: :/,
                    args: {
                      NODE_LIST: [
                        NODE_RATIONAL: 17
                      ]
                    }
                  }
                },
                mid: :%,
                args: {
                  NODE_LIST: [
                    {
                      NODE_INTEGER: 1
                    }
                  ]
                }
              }
            },
            mid: :/,
            args: {
              NODE_LIST: [
                NODE_RATIONAL: 17
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_call
    result = Kanayago.parse('1/17r.to_i')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_INTEGER: 1
            },
            mid: :/,
            args: {
              NODE_LIST: [
                {
                  NODE_CALL: {
                    recv: {
                      NODE_RATIONAL: 17
                    },
                    mid: :to_i,
                    args: nil
                  }
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_rational_call_with_arg
    result = Kanayago.parse('1/17r.to_i(10)')

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_OPCALL: {
            recv: {
              NODE_INTEGER: 1
            },
            mid: :/,
            args: {
              NODE_LIST: [
                {
                  NODE_CALL: {
                    recv: {
                      NODE_RATIONAL: 17
                    },
                    mid: :to_i,
                    args: {
                      NODE_LIST: [
                        {
                          NODE_INTEGER: 10
                        }
                      ]
                    }
                  }
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
