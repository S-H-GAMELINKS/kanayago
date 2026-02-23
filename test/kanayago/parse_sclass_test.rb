# frozen_string_literal: true

require_relative '../test_helper'

class ParseSclassTest < Minitest::Test
  def test_parse_sclass
    result = Kanayago.parse(<<~CODE)
      class << self
        def method_name
        end
      end
    CODE

    assert_instance_of(Kanayago::ScopeNode, result.ast)
    body = result.ast.body

    assert_instance_of(Kanayago::SingletonClassNode, body)
    assert_instance_of(Kanayago::SelfNode, body.recv)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def pattern_match_target_body
    result = Kanayago.parse(<<~PATTERN_TEST_CODE)
      class << self
        def method_name
        end
      end
    PATTERN_TEST_CODE

    result.ast.body
  end

  def test_case_in_matched
    body = pattern_match_target_body

    case body
    in Kanayago::SingletonClassNode
      assert_instance_of(Kanayago::SingletonClassNode, body)
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

    body in Kanayago::SingletonClassNode

    assert_instance_of(Kanayago::SingletonClassNode, body)
  end

  def test_right_assignment
    body = pattern_match_target_body

    body => Kanayago::SingletonClassNode

    assert_instance_of(Kanayago::SingletonClassNode, body)
  end
end
