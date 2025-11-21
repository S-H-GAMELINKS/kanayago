# frozen_string_literal: true

require_relative '../test_helper'

class ParseIterTest < Minitest::Test
  def test_parse_iter_with_do_end_block
    result = Kanayago.parse(<<~CODE)
      [1, 2, 3].each do |x|
        puts x
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
    assert_instance_of(Kanayago::CallNode, body.iter)
  end

  def test_parse_iter_with_curly_braces
    result = Kanayago.parse(<<~CODE)
      [1, 2, 3].map { |x| x * 2 }
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    refute_nil(body.body)
    refute_nil(body.iter)
  end

  def test_parse_iter_with_times
    result = Kanayago.parse(<<~CODE)
      3.times do
        puts "hello"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
  end
end
