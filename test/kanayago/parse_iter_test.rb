# frozen_string_literal: true

require_relative '../test_helper'

class ParseIterTest < Minitest::Test
  def test_parse_iter_with_do_end_block
    result = Kanayago.parse(<<~CODE)
      [1, 2, 3].each do |x|
        puts x
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
    assert_instance_of(Kanayago::CallNode, body.iter)
  end

  def test_parse_iter_with_curly_braces
    result = Kanayago.parse(<<~CODE)
      [1, 2, 3].map { |x| x * 2 }
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
    refute_nil(body.body)
    refute_nil(body.iter)
  end

  def test_parse_iter_with_times
    result = Kanayago.parse(<<~CODE)
      3.times do
        puts "hello"
      end
    CODE

    body = result.ast.body

    assert_instance_of(Kanayago::IterNode, body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      [1, 2, 3].each do |x|
        puts x
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::IterNode
      assert_instance_of(Kanayago::IterNode, body)
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

    body in Kanayago::IterNode

    assert_instance_of(Kanayago::IterNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::IterNode

    assert_instance_of(Kanayago::IterNode, body)
  end
end
