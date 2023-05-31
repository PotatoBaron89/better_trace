# # frozen_string_literal: true

module BetterTrace
  module TraceStack
    def stack!(bind)
      puts "Tracing Stack".yellow

      Stack.new(bind)
    end
  end

  include TraceStack
  module_function :stack!
end