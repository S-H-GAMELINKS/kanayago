# frozen_string_literal: true

require_relative '../test_helper'

class ParseSuperTest < Minitest::Test
  def test_parse_super
    result = Kanayago.parse(<<~CODE)
      class Parent
        def method_name(arg)
          arg
        end
      end

      class Child < Parent
        def method_name(arg)
          super(arg)
        end
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::BlockNode, body)
    child_class = body[1]

    assert_instance_of(Kanayago::ClassNode, child_class)
    child_body = child_class.body

    assert_instance_of(Kanayago::ScopeNode, child_body)
    method_def = child_body.body

    assert_instance_of(Kanayago::DefinitionNode, method_def)
    method_body = method_def.defn

    assert_instance_of(Kanayago::ScopeNode, method_body)
    super_node = method_body.body

    assert_instance_of(Kanayago::SuperNode, super_node)
    assert_instance_of(Kanayago::ListNode, super_node.args)
  end
end
