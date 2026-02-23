# frozen_string_literal: true

require_relative '../test_helper'

class ParseClassTest < Minitest::Test
  def test_parse_class
    result = Kanayago.parse(<<~CODE)
      class Kanayago
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    assert_nil(result.ast.args)

    body = result.ast.body

    assert_instance_of(Kanayago::ClassNode, body)
    assert_nil(body.super)

    class_path = body.cpath

    assert_instance_of(Kanayago::Colon2Node, class_path)
    assert_equal(:Kanayago, class_path.mid)
    assert_nil(class_path.head)

    class_body = body.body

    assert_instance_of(Kanayago::ScopeNode, class_body)
    assert_nil(class_body.args)
    assert_instance_of(Kanayago::BeginNode, class_body.body)
    assert_nil(class_body.body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      class Kanayago
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ClassNode
      assert_instance_of(Kanayago::ClassNode, body)
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

    body in Kanayago::ClassNode

    assert_instance_of(Kanayago::ClassNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ClassNode

    assert_instance_of(Kanayago::ClassNode, body)
  end
end
