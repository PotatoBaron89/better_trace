# # frozen_string_literal: true
# # rubocop:disable all

module BetterTrace
  module TraceStack
    class Stack
      include StackHelpers
      attr_accessor :bind, :local_vars, :instance_vars

      def initialize(line, bind, context)
        self.bind = bind
        self.local_vars = local_vars_from_binding(bind)
        self.instance_vars = instance_vars_from_binding(bind)
      end

    end
  end
end