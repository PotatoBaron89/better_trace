# frozen_string_literal: true

module BetterTrace
  module TraceStack
    class StackTrace
      include StackHelpers
      attr_accessor :bind, :i_count, :in_sync, :lines, :stacks



      def initialize(bind)
        raise unless bind.is_a?(Binding)

        self.bind = bind
        self.i_count = 0
        self.in_sync = false
        self.lines = bind.caller
        self.stacks = []

        process!
      end

      def process!
        lines.each do |line|
          break if (i_count >= self.depth)

          if not_dangerous? && not_a_binding?
            self.stacks << Stack.new(line, current_bind, self)
          end

          self.i_count += 1
        end
      end

      def not_a_binding?
        current_bind.eval('self.class') == Binding
      end

      def not_dangerous?
        LINES_THAT_BREAK_STUFF.any? { |l| line.include?(l) }
      end

      def current_bind
        self.bind.of_caller(i_count)
      end

      def depth
        @depth ||= bind.callers.count -1
      end
    end
  end
end