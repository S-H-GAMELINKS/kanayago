# frozen_string_literal: true

require_relative '../test_helper'

class ParseColon3Test < Minitest::Test
  def test_parse_colon3_node
    result = Kanayago.parse('::String')

    body = result.ast.body

    assert_instance_of(Kanayago::Colon3Node, body)
    assert_equal(:String, body.mid)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      ::String
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::Colon3Node
      assert_instance_of(Kanayago::Colon3Node, body)
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

    body in Kanayago::Colon3Node

    assert_instance_of(Kanayago::Colon3Node, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::Colon3Node

    assert_instance_of(Kanayago::Colon3Node, body)
  end
end
