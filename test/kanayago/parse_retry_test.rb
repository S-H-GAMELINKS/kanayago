# frozen_string_literal: true

require_relative '../test_helper'

class ParseRetryTest < Minitest::Test
  def test_parse_retry_in_rescue
    result = Kanayago.parse(<<~CODE)
      begin
        raise
      rescue
        retry
      end
    CODE

    body = result.body

    assert_instance_of(Kanayago::RescueNode, body)

    rescue_body = body.resq

    assert_instance_of(Kanayago::RescueBodyNode, rescue_body)
    assert_instance_of(Kanayago::RetryNode, rescue_body.body)
  end
end
