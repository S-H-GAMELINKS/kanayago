# frozen_string_literal: true

require_relative '../test_helper'

class ParseDefsTest < Minitest::Test
  def test_parse_defs
    result = Kanayago.parse(<<~CODE)
      def self.kanayago
        p 117
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::SingletonDefinitionNode, body)
    assert_equal(:kanayago, body.mid)
    assert_instance_of(Kanayago::SelfNode, body.recv)
    assert_instance_of(Kanayago::ScopeNode, body.defn)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      def self.kanayago
        p 117
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::SingletonDefinitionNode
      assert_instance_of(Kanayago::SingletonDefinitionNode, body)
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

    body in Kanayago::SingletonDefinitionNode

    assert_instance_of(Kanayago::SingletonDefinitionNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::SingletonDefinitionNode

    assert_instance_of(Kanayago::SingletonDefinitionNode, body)
  end
end
