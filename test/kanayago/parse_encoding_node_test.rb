# frozen_string_literal: true

require_relative '../test_helper'

class ParseEncodingNodeTest < Minitest::Test
  def test_parse_encoding_node
    result = Kanayago.parse('__ENCODING__')

    body = result.ast.body

    assert_instance_of(Kanayago::EncodingNode, body)
    assert_equal(Encoding::UTF_8, body.val)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      __ENCODING__
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::EncodingNode
      assert_instance_of(Kanayago::EncodingNode, body)
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

    body in Kanayago::EncodingNode

    assert_instance_of(Kanayago::EncodingNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::EncodingNode

    assert_instance_of(Kanayago::EncodingNode, body)
  end
end
