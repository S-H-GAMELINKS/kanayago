# frozen_string_literal: true

require_relative '../test_helper'

class ParseValiasNodeTest < Minitest::Test
  def test_parse_valias_node
    result = Kanayago.parse('alias $v $g')

    body = result.ast.body

    assert_instance_of(Kanayago::ValiasNode, body)
    assert_equal(:$v, body.alias)
    assert_equal(:$g, body.original)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      alias $v $g
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::ValiasNode
      assert_instance_of(Kanayago::ValiasNode, body)
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

    body in Kanayago::ValiasNode

    assert_instance_of(Kanayago::ValiasNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::ValiasNode

    assert_instance_of(Kanayago::ValiasNode, body)
  end
end
