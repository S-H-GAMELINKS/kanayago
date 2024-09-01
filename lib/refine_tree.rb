# frozen_string_literal: true

require_relative 'refine_tree/version'
require_relative 'refine_tree/refine_tree'

# Parse Ruby code with Ruby's Parser(Universal Parser)
module RefineTree
  def self.parse(source)
    refine_tree_parse(source)
  end
end
