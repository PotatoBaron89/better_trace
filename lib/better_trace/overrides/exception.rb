# frozen_string_literal: true

class Exception
  def self.config
    BetterTrace.config
  end

  def self.===(other)
    unless trace_in_progress? || !override_enabled?
      self.trace_in_progress = true
      is_rescued = caller_locations[0].label.include?("rescue in block")

      cl = caller_locations[0]
      path = (cl.path.to_s.split("/")[-3..-1] || file_path.split("/")).join("/")
      msg = <<~MSG
        #{"       - - -  ⚠️   Rescued Exception   ⚠️ - - - ".white.bold}
            #{("#{path}:#{cl.lineno.to_s}").yellow}
            #{other.inspect.yellow}
      MSG

      caller_locations.first(5).each { |l| puts "            #{l.to_s.yellow}" }

      puts msg
      BetterTrace.logged_exceptions << LoggedException.new(other, binding, caller_locations, is_rescued)
    end
    self.trace_in_progress = false
    super
  end

  def self.trace_in_progress
    Thread.current[:_trace_in_progress]
  end

  def self.trace_in_progress=(val)
    Thread.current[:_trace_in_progress] = val
  end

  def self.trace_in_progress?
    !!trace_in_progress
  end

  # Should be moved to better_trace.rb
  def self.override_on
    Thread.current[:_trace_override_status] ||= true
  end

  def self.override_on=(val)
    Thread.current[:_trace_override_status] = val
  end

  def self.override_enabled?
    !!override_on
  end
end
