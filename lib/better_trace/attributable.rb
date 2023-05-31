# frozen_string_literal: true


module BetterTrace
  module Attributable
    extend ActiveSupport::Concern

    def self.extended(mod)
      mod.instance_eval do
        class_attribute :attributes
        self.attributes = {}
      end
    end


    def attribute(attr_name, default: nil, with_bool: nil)
      return if attributes.include?(attr_name)

      attributes.merge!({ attr_name => { default: default, helpers: with_bool } })
      attr_accessor attr_name

      define_method(with_bool) { !!attr_name } if with_bool
    end
  end
end
