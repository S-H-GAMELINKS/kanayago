# frozen_string_literal: true

require_relative '../test_helper'

class ParseZsuperTest < Minitest::Test
  def test_parse_zsuper
    result = Kanayago.parse(<<~CODE)
      class Parent
        def method_name(arg)
          arg
        end
      end

      class Child < Parent
        def method_name(arg)
          super
        end
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::BlockNode, body)
    child_class = body[1]

    assert_instance_of(Kanayago::ClassNode, child_class)
    child_body = child_class.body

    assert_instance_of(Kanayago::ScopeNode, child_body)
    method_def = child_body.body

    assert_instance_of(Kanayago::DefinitionNode, method_def)
    method_body = method_def.defn

    assert_instance_of(Kanayago::ScopeNode, method_body)
    zsuper_node = method_body.body

    assert_instance_of(Kanayago::ZeroSuperNode, zsuper_node)
  end
end
