# frozen_string_literal: true

module BetterTrace

  class Config
    extend Attributable

    attribute :reject_filter, default: RejectFilter.new
    attribute :highlight_filter, default: HighlightFilter.new
    attribute :source_filter, default: SourceFilter.new

    attribute :core, default: Core.new
    delegate(*Core::DELEGATED_METHODS, to: :core)


    attribute :tracked_objects, default: []                 # default: [], an array of object_ids to track

    def initialize(*args)
      opts = args.extract_options!

      self.attributes.each do |k, v|
        self.send("#{k}=", opts[k] || override_defaults[k] || v[:default])
      end
    end

    class GemResults
      extend Attributable

      attribute :state, default: :gray
      attribute :show_source, default: false, cond_method: :show_source?

      def initialize
        @state = :gray
        @show_source = false
      end

      def grayed?
        @state == :gray
      end

      def hide?
        @state == :hide
      end

      def show?
        @state == :show
      end

      def show_source?
        !!@show_source
      end
    end

    def self.delegated_methods
      (attributes.keys + helper_methods).uniq
    end

    def self.helper_methods
      self.attributes.map { |k, v| v.dig(:helpers) }.compact
    end

    private

    # Personal use until I build things out
    def override_defaults
      {
        skip_bindings: false,
        indent_value: 3,
        highlight_lines: ["better_trace"]
      }
    end
  end
end