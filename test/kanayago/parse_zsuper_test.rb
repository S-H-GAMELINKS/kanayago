# frozen_string_literal: true

require_relative '../test_helper'

class ParseZsuperTest < Minitest::Test
  def test_parse_zsuper
    result = Kanayago.parse(<<~CODE)
      class Parent
        def method_name(arg)
          arg
        end
      end

      class Child < Parent
        def method_name(arg)
          super
        end
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::BlockNode, body)
    child_class = body[1]

    assert_instance_of(Kanayago::ClassNode, child_class)
    child_body = child_class.body

    assert_instance_of(Kanayago::ScopeNode, child_body)
    method_def = child_body.body

    assert_instance_of(Kanayago::DefinitionNode, method_def)
    method_body = method_def.defn

    assert_instance_of(Kanayago::ScopeNode, method_body)
    zsuper_node = method_body.body

    assert_instance_of(Kanayago::ZeroSuperNode, zsuper_node)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      class Parent
        def method_name(arg)
          arg
        end
      end

      class Child < Parent
        def method_name(arg)
          super
        end
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::BlockNode
      assert_instance_of(Kanayago::BlockNode, body)
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

    body in Kanayago::BlockNode

    assert_instance_of(Kanayago::BlockNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::BlockNode

    assert_instance_of(Kanayago::BlockNode, body)
  end
end
