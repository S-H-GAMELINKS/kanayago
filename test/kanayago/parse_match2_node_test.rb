# frozen_string_literal: true

require_relative '../test_helper'

class ParseMatch2NodeTest < Minitest::Test
  def test_parse_match2_node
    result = Kanayago.parse('/foo/ =~ "bar"')

    body = result.ast.body

    assert_instance_of(Kanayago::Match2Node, body)
    assert_instance_of(Kanayago::RegexpNode, body.recv)
    assert_instance_of(Kanayago::StringNode, body.value)
    assert_equal('foo', body.recv.ptr)
  end

  def test_parse_match2_node_with_captures
    result = Kanayago.parse('/(?<name>\w+)/ =~ "test"')

    body = result.ast.body

    assert_instance_of(Kanayago::Match2Node, body)
    # nd_args should contain capture assignments when named captures exist
    refute_nil(body.args) if body.recv.ptr.include?('?<')
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      /foo/ =~ "bar"
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::Match2Node
      assert_instance_of(Kanayago::Match2Node, body)
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

    body in Kanayago::Match2Node

    assert_instance_of(Kanayago::Match2Node, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::Match2Node

    assert_instance_of(Kanayago::Match2Node, body)
  end
end
