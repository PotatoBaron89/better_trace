# frozen_string_literal: true

module BetterTrace
  module TraceStack
    module StackHelpers

      def local_vars_from_binding(b)
        local_vars = {}

        b.eval("local_variables").each do |k|
          local_vars.merge!({ k => b.local_variable_get(k) }) unless k == :line
          local_vars.except(*LOCAL_IGNORED)
        end
      end

      def instance_vars_from_binding(b)
        instance_vars = {}

        b.instance_variables.each do |k|
          instance_vars.merge!({ k => b.instance_variable_get(k) })
        end
      end

      def output_vars(vars, header: "Variables")
        vars.each do |k, v|
          # TODO: Add config to allow customisation
          puts "     - #{ k }: ".pink + v.to_s.truncate(65).yellow
        end
      end

      def vars_similar(var, var2)
        return true if var == var2
        return true if var.object_id == var2.object_id
        return true if var.to_s == var2.to_s

        false
      end
    end
  end
end