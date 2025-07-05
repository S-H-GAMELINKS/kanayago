# frozen_string_literal: true

require_relative 'kanayago/version'
require_relative 'kanayago/kanayago'

require_relative 'kanayago/literal_node'
require_relative 'kanayago/string_node'
require_relative 'kanayago/statement_node'
require_relative 'kanayago/variable_node'

# Parse Ruby code with Ruby's Parser(Universal Parser)
module Kanayago
  def self.parse(source)
    kanayago_parse(source)
  end

  class SelfNode
    attr_reader :state
  end

  class ModuleNode
    attr_reader :cpath, :body
  end

  class VariableCallNode
    attr_reader :mid
  end
end
