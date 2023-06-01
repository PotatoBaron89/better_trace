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


    def attribute(attr_name, default: nil, cond_method: nil)
      return if attributes.include?(attr_name)

      attributes.merge!({ attr_name => { default: default, helpers: cond_method } })
      attr_accessor attr_name

      define_method(cond_method) { !!attr_name } if cond_method
    end
  end
end
