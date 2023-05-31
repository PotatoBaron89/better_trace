# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "pry"
require 'coderay'

require_relative "better_trace/version"

require_relative "better_trace/overrides/overrides/rescued_exception"
require_relative "better_trace/overrides/exception"
require_relative "better_trace/overrides/array"
require_relative "better_trace/overrides/object"
require_relative "better_trace/overrides/string"

require_relative "better_trace/constants"
require_relative "better_trace/attributable"
require_relative "better_trace/config"

require_relative "better_trace/trace_stack"
require_relative "better_trace/trace_stack/stack_helpers"
require_relative "better_trace/trace_stack/stack"
require_relative "better_trace/trace_stack/stack_trace"


puts "Running BetterTrace #{BetterTrace::VERSION}".yellow

module BetterTrace
  class Error < StandardError; end

  mattr_accessor :config, default: Config.new
  mattr_accessor :rescued_exceptions, default: []

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

    def version
      VERSION
    end
  end
end
