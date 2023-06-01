module BetterTrace
  module TraceStack
    class Frame
      extend BetterTrace::Attributable
      LOCAL_IGNORED = [:_, :__, :___, :$!, :depth, :i_vars, :local_vars, :i_count]
      IGNORED_METHODS = ["main", "eval", "require", "require_relative"]
      ILLEGAL_METHOD_CHARS = ["`", "'", "<", ">", "block "]


      attr_accessor :binding, :method, :line, :file, :binding_location, :trace, :caller_locations
      def initialize(binding, trace)
        @binding = binding
        @binding_location = binding.source_location.first
        @trace = trace.map do |t|
          (t.to_s.split("/")[-4..-1] || file_path.split("/")).join("/")
        end

        @caller_locations = @binding.eval('caller_locations') unless @binding.eval('self').is_a?(Binding)
        @method = get_method_from_line(@caller_locations.first.to_s)
        @line = @caller_locations.first.lineno
        @file = @caller_locations.first.path
      end

      def local_vars
        @local_vars ||= local_vars_from_binding
      end

      def i_vars
        @instance_vars ||= i_vars_from_binding
      end

      def local_vars_from_binding
        local_vars = {}
        @binding.eval("local_variables").each do |k|
          # Have a bug with :line that  I haven't figured out yet
          local_vars.merge!({ k => @binding.local_variable_get(k) }) unless k == :line
          local_vars = local_vars.except(*LOCAL_IGNORED)
        end

        local_vars
      end

      def i_vars_from_binding
        vars = {}

        @binding.instance_variables.each do |k|
          next if k == :@iseq

          vars.merge!({ k => @binding.instance_variable_get(k) })
        end

        vars
      end

      def output_vars(local_vars, i_vars)
        puts "Local variables: ".white
        local_vars.each do |k, v|
          puts "     - #{ k }:  ".pink + v.to_s.truncate(65).yellow
        end

        puts "Instance variables: ".white
        i_vars.each do |k, v|
          puts "     - #{ k }: ".pink + v.to_s.truncate(65).yellow
        end
      end

      def get_method_from_line(line)
        method = line.match(/(?<=:in\s)(.+)/)
        method = method.to_s.gsub!("`", "").gsub!("'", "")
        method = method[1..-2] if method[0] == "<" && method[-1] == ">"
        return "" if method.in?(IGNORED_METHODS)

        method
      end

      def show_source_for(bind, method, line)
        # return if show_verbose_for_line(line)

        bind.eval_method_source(method)
      end
    end
  end
end