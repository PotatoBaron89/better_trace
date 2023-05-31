# frozen_string_literal: true

module BetterTrace

  LOCAL_IGNORED = [:_, :__, :___, :$!, :depth, :i_vars, :local_vars, :i_count]

  LINES_THAT_BREAK_STUFF = %w[console_command.rb rails/command.rb rake_module.rb:59 rake_command.rb:24 /application.rb:116 thor/command.rb:27]

  OPTIONS_TEXT = <<~MSG
        highlight_filter:       Array of strings to filter out of the stack trace
        show_source_for_gems:   Boolean to show source for gems
        ignored_lines:          Array of strings to ignore in the stack trace
                                If highlight_filter matches, it will be displayed
        indent_value:           Integer for the indent value, used by errors during this process
        debug_indent_value:     Integer for the indent value, used by errors during this process


        reject_gem_lines
        tracked_objects:        Array of object_ids to track
        some_object.track!
        some_object.compare_to(user2)
        skip_bindings?
  MSG

  ALL_METHODS = <<~MSG
        should_be_ignored_in_trace(line)
        highlight_line?
        skip_bindings?
  MSG
end