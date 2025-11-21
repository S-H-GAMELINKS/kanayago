# frozen_string_literal: true

require_relative '../test_helper'

class ParseModuleNodeTest < Minitest::Test
  def test_parse_module_node
    result = Kanayago.parse(<<~CODE)
      module Kanayago
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::ModuleNode, body)
    assert_instance_of(Kanayago::Colon2Node, body.cpath)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_nested_module_with_outer_constant_reference
    code = <<~RUBY
      class UserRole
        FLAGS = {
          admin: (1 << 0),
          user: (1 << 1),
          guest: (1 << 2)
        }

        module Flags
          ALL = FLAGS.values.reduce(&:|)
          DEFAULT = FLAGS[:user]
        end
      end
    RUBY

    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    refute_nil(result.ast.body)
  end
end
