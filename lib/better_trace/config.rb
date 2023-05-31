# frozen_string_literal: true

module BetterTrace

  class Config
    extend Attributable

    attribute :skip_bindings, default: false, with_bool: :skip_bindings?    # default: false, if enabled, skips all binding.pry calls
    attribute :indent_value, default: 3                                     # default: 2, the number of spaces to indent each line
    attribute :highlight_lines, default: []                                 # default: [], an array of strings to highlight in the stack trace
    attribute :reject_lines, default: []                                    # default: [], an array of strings to reject in the stack trace, if highlight_lines matches, it will be displayed

    attribute :reject_gem_lines, default: false,                            # default: false, if enabled, rejects all gem lines
              with_bool: :reject_gem_lines?
    attribute :show_source_for_gems, default: true,                        # default: false, if enabled, shows source for gems
              with_bool: :show_source_for_gems?

    attribute :tracked_objects, default: []                                 # default: [], an array of object_ids to track

    def initialize(*args)
      # TODO: Setup handling of args, this is placeholder
      opts = args.extract_options!

      self.attributes.each do |k, v|
        self.send("#{k}=", opts[k] || override_defaults[k] || v[:default])
      end

      @opts = opts
      @args = args
    end

    class GemResults
      extend Attributable

      attribute :state, default: :gray
      attribute :show_source, default: false, with_bool: :show_source?

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
      self.attributes.map {|k, v| v.dig(:helpers) }.compact
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