# frozen_string_literal: true

class Array

  module DebugHelpers
    def as_trace
      self.select {|t| BetterTrace.should_be_included_in_trace?(t.to_s) }
          .map {|t| t.to_s.format_trace }.join("\n")
    end
  end

  include DebugHelpers
end
