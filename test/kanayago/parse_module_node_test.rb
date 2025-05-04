# frozen_string_literal: true

require_relative '../test_helper'

class ParseModuleNodeTest < Minitest::Test
  def test_parse_module_node
    result = Kanayago.parse(<<~CODE)
      module Kanayago
      end
    CODE

    body = result.body

    assert_instance_of(Kanayago::ModuleNode, body)
    assert_instance_of(Kanayago::Colon2Node, body.cpath)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end
end
