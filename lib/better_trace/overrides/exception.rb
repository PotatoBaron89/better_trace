# frozen_string_literal: true

class Exception

  def self.===(other)
    unless trace_in_progress? || !override_enabled?
      self.trace_in_progress = true
      is_rescued = caller_locations[0].label.include?("rescue in block")

      BetterTrace.logged_exceptions << LoggedException.new(other, binding, is_rescued)
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
