# frozen_string_literal: true

class LoggedException

  extend BetterTrace::Attributable # Need to swap from attr_accessor
  # attr_accessor :exception, :error_klass, :path, :trace, :is_rescued, :frames, :caller_locations
  attribute :exception
  attribute :error_klass
  attribute :path
  attribute :trace
  attribute :is_rescued
  attribute :frames
  attribute :caller_locations

  def initialize(exception, binding, caller_locations, is_rescued)
    @exception = exception
    @error_klass = exception.class
    @is_rescued = is_rescued
    @binding = binding
    @caller_locations = caller_locations

    @depth = binding.callers.count - 1
    @frames = []
    build_frames!
  end

  def build_frames!
    Thread.current[:_trace_override_status] = false

    i_count = 1 # skip 0
    while i_count < @depth
      @frames << BetterTrace::TraceStack::Frame.new(binding.of_caller(i_count), @caller_locations)
      i_count += 1
    end
  ensure
    Thread.current[:_trace_override_status] = true
  end

  def output_frames
    @frames.each do |frame|
      puts frame.to_s
    end
  end

  # def trace_stack!
  #   i_count = 0
  #
  #   lines.map do |line|
  #     break if (i_count + 1).to_i >= depth.to_i
  #     i_count += 1
  #
  #     begin
  #     current_binding = binding.of_caller(i_count)
  #     rescue Exception => e
  #       puts "No such frame, gone beyond end of stack!".bg_red.white
  #       break
  #     end
  #
  #
  #     break if line.include?("rake_module.rb:59") || line.include?("rake_command.rb:24") || line.include?("/application.rb:116") || line.include?("rails/command.rb") || line.include?("console_command.rb") || line.include?("thor/command.rb:27")
  #     next if self.is_a?(Binding)
  #
  #     unless in_sync
  #       next if skip_this_trace?(current_binding, line)
  #
  #       in_sync = true
  #     end
  #
  #     puts "[#{i_count}] ".white.bg_black + line.to_s.format_trace
  #
  #     method = get_method_from_line(line)
  #     next if method.blank?
  #
  #     unless ILLEGAL_METHOD_CHARS.any? { |c| method.to_s.include?(c) }
  #       show_source_for(current_binding, method, line)
  #       local_vars, i_vars = vars_from_binding(current_binding)
  #     end
  #
  #     output_vars(local_vars, i_vars) if line.should_be_listed_in_trace?
  #   end
  # end


end
