# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "pry"
require 'coderay'
require 'binding_of_caller'

require_relative "better_trace/version"

require_relative "better_trace/overrides/exception"
require_relative "better_trace/overrides/array"
require_relative "better_trace/overrides/object"
require_relative "better_trace/overrides/string"

require_relative "better_trace/constants"
require_relative "better_trace/attributable"
require_relative "better_trace/config"

require_relative "better_trace/trace_stack"
require_relative "better_trace/trace_stack/stack_helpers"
require_relative "better_trace/trace_stack/frame"
require_relative "better_trace/trace_stack/stack"
require_relative "better_trace/trace_stack/stack_trace"

require_relative "better_trace/overrides/overrides/logged_exception"

puts "Running BetterTrace #{BetterTrace::VERSION}".yellow

module BetterTrace
  class Error < StandardError; end

  mattr_accessor :config, default: Config.new
  mattr_accessor :logged_exceptions, default: []

  class << self
    delegate(*Config.delegated_methods, to: :config)

    def stack_trace!(bind)
      puts "Tracing Stack".yellow

      TraceStack::StackTrace.new(bind)
    end

    def highlight_line?(line)
      config.highlight_lines.any? { |l| line.include?(l) }
    end

    def should_be_included_in_trace?(line)
      return true if highlight_line?(line)
      return false if should_be_ignored_in_trace?(line)

      true
    end

    def should_be_ignored_in_trace?(line)
      ((line.include?("/ruby/")) && reject_gem_lines?) ||
        config.reject_lines.any? { |l| line.include?(l) }
    end

    # Exception Overrides

    def exception_override_disabled
      return unless block_given?

      self.override_on = false
      yield
      self.override_on = yield
    end

    def override_on
      Thread.current[:_trace_override_status] ||= true
    end

    def override_on=(val)
      Thread.current[:_trace_override_status] = val
    end

    def override_enabled?
      !!override_on
    end

    def version
      VERSION
    end
  end
end
