# frozen_string_literal: true

require_relative '../test_helper'

class ParseLambdaTest < Minitest::Test
  def test_parse_lambda_no_args
    result = Kanayago.parse('-> { 42 }')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::LambdaNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_parse_lambda_with_args
    result = Kanayago.parse('->(x) { x * 2 }')

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::LambdaNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_parse_lambda_multiline
    code = <<~RUBY
      ->(x, y) {
        x + y
      }
    RUBY
    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::LambdaNode, body)
    assert_instance_of(Kanayago::ScopeNode, body.body)
  end

  def test_parse_lambda_do_end
    code = 'lambda do |x| x * 2 end'
    result = Kanayago.parse(code)

    assert_instance_of(Kanayago::ScopeNode, result)
    body = result.body

    assert_instance_of(Kanayago::IterNode, body)
  end
end
