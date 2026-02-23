# frozen_string_literal: true

module Kanayago
  class BaseNode
    def self.node_attributes(*names)
      if names.any?
        @__node_attributes__ = names.freeze
        names.each { |name| attr_reader name.to_sym }
      end

      @__node_attributes__ || []
    end

    def deconstruct
      self.class.node_attributes.filter_map do |name|
        public_send(name) if respond_to?(name)
      end
    end

    def deconstruct_keys(keys)
      names = keys.nil? ? self.class.node_attributes : keys

      names.each_with_object({}) do |name, values|
        values[name] = public_send(name) if respond_to?(name)
      end
    end
  end
end
