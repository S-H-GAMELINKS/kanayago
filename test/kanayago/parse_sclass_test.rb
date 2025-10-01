# frozen_string_literal: true

require_relative '../test_helper'

class ParseSclassTest < Minitest::Test
  def test_parse_sclass
    result = Kanayago.parse(<<~CODE)
      class << self
        def method_name
        end
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::SingletonClassNode, body)
    assert_instance_of(Kanayago::SelfNode, body.recv)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end
end
