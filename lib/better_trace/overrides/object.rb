# frozen_string_literal: true

class Object

  module DebugHelpers

    def trace_stack!
      StackTracer.trace_stack!
    end

    def source(method_name, try: false)
      method_name = method_name.to_sym if method_name.is_a?(String)

      path = self.method(method_name).source_location.join(":").gsub("/home/ruby/core/repo/", "")
      source = self.method(method_name).source

      # TODO: TIDY UP
      puts "\nPath: #{path.to_s}\n\n\n"
      puts CodeRay.scan(source, :ruby).term
      puts "\n\n\n"

      nil
    end
  end

end