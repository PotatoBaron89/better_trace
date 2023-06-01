

module BetterTrace
  class Config
    class Core
      extend Attributable

      DELEGATED_METHODS = %i[without_override enable_override disable_override exception_override_disabled?].freeze

      def without_override
        return unless block_given?

        enable_override
        yield
        disable_override
      end

      def enable_override
        Thread.current[:_trace_override_status] ||= true
      end

      def disable_override
        Thread.current[:_trace_override_status] ||= false
      end

      def exception_override_enabled?
        !!Thread.current[:_trace_override_status]
      end

    end
  end
end
