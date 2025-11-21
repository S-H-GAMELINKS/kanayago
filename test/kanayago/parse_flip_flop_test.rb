# frozen_string_literal: true

require_relative '../test_helper'

class ParseFlipFlopTest < Minitest::Test
  def test_parse_inclusive_flip_flop
    result = Kanayago.parse(<<~CODE)
      if (1==1)..(2==2)
        puts "ok"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    if_node = result.ast.body

    assert_instance_of(Kanayago::IfStatementNode, if_node)

    flip_flop = if_node.cond

    assert_instance_of(Kanayago::FlipFlopNode, flip_flop)
    refute_nil(flip_flop.beg)
    refute_nil(flip_flop.end)
  end

  def test_parse_exclusive_flip_flop
    result = Kanayago.parse(<<~CODE)
      if (1==1)...(2==2)
        puts "ok"
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    if_node = result.ast.body

    assert_instance_of(Kanayago::IfStatementNode, if_node)

    flip_flop = if_node.cond

    assert_instance_of(Kanayago::ExclusiveFlipFlopNode, flip_flop)
    refute_nil(flip_flop.beg)
    refute_nil(flip_flop.end)
  end
end
