# frozen_string_literal: true

require_relative '../test_helper'

class ParseClassTest < Minitest::Test
  def test_parse_class
    result = Kanayago.parse(<<~CODE)
      class Kanayago
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    assert_nil(result.args)

    body = result.body

    assert_instance_of(Kanayago::ClassNode, body)
    assert_nil(body.super)

    class_path = body.cpath

    assert_instance_of(Kanayago::Colon2Node, class_path)
    assert_equal(:Kanayago, class_path.mid)
    assert_nil(class_path.head)

    class_body = body.body

    assert_instance_of(Kanayago::ScopeNode, class_body)
    assert_nil(class_body.args)
    assert_instance_of(Kanayago::BeginNode, class_body.body)
    assert_nil(class_body.body.body)
  end
end
