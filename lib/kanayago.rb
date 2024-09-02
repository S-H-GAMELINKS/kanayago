# frozen_string_literal: true

require_relative 'kanayago/version'
require_relative 'kanayago/kanayago'

# Parse Ruby code with Ruby's Parser(Universal Parser)
module Kanayago
  def self.parse(source)
    kanayago_parse(source)
  end
end
