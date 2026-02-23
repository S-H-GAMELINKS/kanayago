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

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      def kanayago
        p 117
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::DefinitionNode
      assert_instance_of(Kanayago::DefinitionNode, body)
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

    body in Kanayago::DefinitionNode

    assert_instance_of(Kanayago::DefinitionNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::DefinitionNode

    assert_instance_of(Kanayago::DefinitionNode, body)
  end
end
