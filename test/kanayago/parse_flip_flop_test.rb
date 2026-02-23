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

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      if (1==1)..(2==2)
        puts "ok"
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::IfStatementNode
      assert_instance_of(Kanayago::IfStatementNode, body)
    end
  end

  def test_case_in_unmatched
    body = pattern_match_target_body

    assert_raises(NoMatchingPatternError) do
      case body.class.name
      in '__kanayago_unmatched_pattern__'
        # Nothing to do
      end
    end
  end

  def test_single_in
    body = pattern_match_target_body

    body in Kanayago::IfStatementNode

    assert_instance_of(Kanayago::IfStatementNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::IfStatementNode

    assert_instance_of(Kanayago::IfStatementNode, body)
  end
end
