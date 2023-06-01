

module BetterTrace
  class Config
    class Filters
      extend Attributable

      attribute :path_filter, default: []
      attribute :line_filter, default: []
      attribute :method_filter, default: []
      attribute :gem_filter, default: []
      attribute :custom_filter, default: []
      attribute :proc_filter, default: []

      attribute :path_filter_enabled, default: true, cond_method: :path_filter_enabled?
      attribute :line_filter_enabled, default: true, cond_method: :line_filter_enabled?
      attribute :method_filter_enabled, default: true, cond_method: :method_filter_enabled?
      attribute :gem_filter_enabled, default: true, cond_method: :gem_filter_enabled?
      attribute :custom_filter_enabled, default: true, cond_method: :custom_filter_enabled?
      attribute :proc_filter_enabled, default: true, cond_method: :proc_filter_enabled?

      self.attributes.each do
        |k, _v| define_method("match_#{k}?") do |str|
          self.send(k).any? { |e| str.include?(e) }
        end
      end
    end

    class RejectFilter < Filters; end
    class HighlightFilter < Filters; end
    class SourceFilter < Filters; end
  end
end