# frozen_string_literal: true

require_relative '../test_helper'

class ParseEncodingNodeTest < Minitest::Test
  def test_parse_encoding_node
    result = Kanayago.parse('__ENCODING__')

    body = result.ast.body

    assert_instance_of(Kanayago::EncodingNode, body)
    assert_equal(Encoding::UTF_8, body.val)
  end
end
