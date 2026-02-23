# frozen_string_literal: true

require_relative '../test_helper'

class ParsePostArgTest < Minitest::Test
  def test_parse_post_argument
    result = Kanayago.parse('def foo(*args, a); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def test_parse_post_arguments_multiple
    result = Kanayago.parse('def bar(*args, a, b); end')

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    defn = result.ast.body

    assert_instance_of(Kanayago::DefinitionNode, defn)
    refute_nil(defn.defn.args)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      def foo(*args, a); end
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
