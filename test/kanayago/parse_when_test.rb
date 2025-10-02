# frozen_string_literal: true

require_relative '../test_helper'

class ParseWhenTest < Minitest::Test
  def test_parse_when_single_condition
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      end
    CODE

    body = result.body.body # CaseNode -> WhenNode

    assert_instance_of(Kanayago::WhenNode, body)

    # head: 条件のリスト
    assert_instance_of(Kanayago::ListNode, body.head)

    # body: when節の本体
    refute_nil(body.body)

    # next: 次のwhen節（この場合はnil）
    assert_nil(body.next)
  end

  def test_parse_when_multiple_conditions
    result = Kanayago.parse(<<~CODE)
      case x
      when 1, 2, 3
        puts "small"
      end
    CODE

    body = result.body.body

    assert_instance_of(Kanayago::WhenNode, body)
    assert_instance_of(Kanayago::ListNode, body.head)
  end

  def test_parse_when_chain
    result = Kanayago.parse(<<~CODE)
      case x
      when 1
        puts "one"
      when 2
        puts "two"
      end
    CODE

    first_when = result.body.body

    assert_instance_of(Kanayago::WhenNode, first_when)

    second_when = first_when.next

    assert_instance_of(Kanayago::WhenNode, second_when)

    assert_nil(second_when.next)
  end
end
