# frozen_string_literal: true

require_relative '../test_helper'

class ParseDefsTest < Minitest::Test
  def test_parse_defs
    result = Kanayago.parse(<<~CODE)
      def self.kanayago
        p 117
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::SingletonDefinitionNode, body)
    assert_equal(:kanayago, body.mid)
    assert_instance_of(Kanayago::SelfNode, body.recv)
    assert_instance_of(Kanayago::ScopeNode, body.defn)
  end
end
