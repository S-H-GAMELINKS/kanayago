# frozen_string_literal: true

require_relative '../test_helper'

class ParseOnceTest < Minitest::Test
  def test_parse_begin_block
    result = Kanayago.parse('BEGIN { puts "hello" }')

    assert_instance_of(Kanayago::ScopeNode, result)
    refute_nil(result.body)
  end
end
