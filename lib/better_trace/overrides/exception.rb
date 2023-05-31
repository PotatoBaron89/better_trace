# frozen_string_literal: true

class Exception

  def self.===(other)
    cl = caller_locations[0]

    unless cl.path.to_s.include?("/active_support/inflector/methods") || cl.path.to_s.include?("/lib/ruby/2.7.0/irb/ruby-lex")
      path = "#{caller_locations[0].path}:#{caller_locations[0].lineno}"
      error = caller_locations[0].label
      is_rescued = error.include?("rescue in block")

      BetterTrace.rescued_exceptions << RescuedException.new(other, path, caller_locations, is_rescued: is_rescued)

      puts "    #{caller_locations.to_a.as_trace}"
    end

    super
  end
end
