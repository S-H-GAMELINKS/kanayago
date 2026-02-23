# frozen_string_literal: true

require_relative '../test_helper'

class ParseConstTest < Minitest::Test
  def test_parse_const
    result = Kanayago.parse('Class')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::ConstantNode, body)
    assert_equal(:Class, body.vid)
  end

  def test_parse_const_ref
    result = Kanayago.parse(<<~CODE)
      S = 117
      p S
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::BlockNode, body)
    assert_equal(2, body.size)

    line = body.first

    assert_instance_of(Kanayago::ConstantDeclarationNode, line)
    assert_equal(:S, line.vid)
    assert_nil(line.else)
    assert_instance_of(Kanayago::IntegerNode, line.value)

    line = body.last

    assert_instance_of(Kanayago::FunctionCallNode, line)
    assert_equal(:p, line.mid)
    assert_instance_of(Kanayago::ListNode, line.args)

    arg = line.args.val.first

    assert_instance_of(Kanayago::ConstantNode, arg)
    assert_equal(:S, arg.vid)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      Class
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ConstantNode
      assert_instance_of(Kanayago::ConstantNode, body)
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

    body in Kanayago::ConstantNode

    assert_instance_of(Kanayago::ConstantNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ConstantNode

    assert_instance_of(Kanayago::ConstantNode, body)
  end
end
