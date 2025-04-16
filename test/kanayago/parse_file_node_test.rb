# frozen_string_literal: true

require_relative '../test_helper'

class ParseFileNOdeTest < Minitest::Test
  def test_parse_file_node
    result = Kanayago.parse('__FILE__')

    body = result.body

    assert_instance_of(Kanayago::FileNode, body)
    assert_equal('main', body.ptr)
    assert_equal(4, body.len)
    assert_equal(Encoding::UTF_8, body.enc)
    assert_equal('RB_PARSER_ENC_CODERANGE_UNKNOWN', body.coderange)
  end
end
