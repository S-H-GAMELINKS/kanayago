# frozen_string_literal: true

require_relative '../test_helper'

class ParseFileNOdeTest < Minitest::Test
  def test_parse_file_node
    result = Kanayago.parse('__FILE__')

    body = result.ast.body

    assert_instance_of(Kanayago::FileNode, body)
    assert_equal('main', body.ptr)
    assert_equal(4, body.len)
    assert_equal(Encoding::UTF_8, body.enc)
    assert_equal('RB_PARSER_ENC_CODERANGE_UNKNOWN', body.coderange)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      __FILE__
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::FileNode
      assert_instance_of(Kanayago::FileNode, body)
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

    body in Kanayago::FileNode

    assert_instance_of(Kanayago::FileNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::FileNode

    assert_instance_of(Kanayago::FileNode, body)
  end
end
