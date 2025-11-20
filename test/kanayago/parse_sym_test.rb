# frozen_string_literal: true

require_relative '../test_helper'

class ParseSymTest < Minitest::Test
  def test_parse_sym
    result = Kanayago.parse(':kanayago')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::SymbolNode, body)
    assert_equal('kanayago', body.ptr)
    assert_equal(8, body.len)
    assert_equal(Encoding::US_ASCII, body.enc)
    assert_equal('RB_PARSER_ENC_CODERANGE_UNKNOWN', body.coderange)
  end
end
