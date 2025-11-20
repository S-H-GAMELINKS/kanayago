# frozen_string_literal: true

require_relative '../test_helper'

class ParseDefnTest < Minitest::Test
  def test_parse_defn
    result = Kanayago.parse(<<~CODE)
      def kanayago
        p 117
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, body)
    assert_equal(:kanayago, body.mid)

    defn = body.defn

    assert_instance_of(Kanayago::ScopeNode, defn)

    args = defn.args

    assert_instance_of(Kanayago::ArgumentsNode, args)

    function_body = defn.body

    assert_instance_of(Kanayago::FunctionCallNode, function_body)
    assert_equal(:p, function_body.mid)
    assert_instance_of(Kanayago::IntegerNode, function_body.args.val.first)
  end
end
