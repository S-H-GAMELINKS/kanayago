# frozen_string_literal: true

require_relative 'kanayago/version'
require_relative 'kanayago/kanayago'

require_relative 'kanayago/literal_node'
require_relative 'kanayago/string_node'
require_relative 'kanayago/statement_node'
require_relative 'kanayago/variable_node'
require_relative 'kanayago/pattern_node'
require_relative 'kanayago/call_node'
require_relative 'kanayago/scope_node'
require_relative 'kanayago/constant_node'

# Parse Ruby code with Ruby's Parser(Universal Parser)
module Kanayago
  def self.parse(source)
    kanayago_parse(source)
  end
end
