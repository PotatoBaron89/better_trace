# frozen_string_literal: true

class String
  ESC = "\u001B["
  OSC = "\u001B]"
  BEL = "\u0007"
  SEP = ";"

  def link_to(url)
    [OSC, "8", SEP, SEP, url, BEL, self, OSC, "8", SEP, SEP, BEL].join
  end

  module Colours
    def colourised?
      !!(self =~ /\033\[\d+(?:;\d+)*m/)
    end

    def strip_colours!
      self.gsub!(/\033\[\d+(?:;\d+)*m/, '')
    end

    def white
      "\e[38;5;7m#{self}\e[0m"
    end

    def red
      "\e[38;5;1m#{self}\e[0m"
    end

    def blue
      "\e[38;5;4m#{self}\e[0m"
    end
    def green
      "\e[38;5;2m#{self}\e[0m"
    end

    def yellow
      "\e[38;5;3m#{self}\e[0m"
    end

    def black
      "\e[38;5;0m#{self}\e[0m"
    end

    def gray
      "\e[38;5;8m#{self}\e[0m"
    end

    def purple
      "\e[38;5;12m#{self}\e[0m"
    end

    def turquoise
      "\e[38;5;14m#{self}\e[0m"
    end

    def aqua
      "\e[38;5;6m#{self}\e[0m"
    end

    def tan
      "\e[38;5;3m#{self}\e[0m"
    end

    def pink
      "\e[38;5;13m#{self}\e[0m"
    end

    def violet
      "\e[38;5;5m#{self}\e[0m"
    end

    def charcoal
      "\e[38;5;8m#{self}\e[0m"
    end

    def burnt_orange
      "\e[38;5;9m#{self}\e[0m"
    end

    # BACKGROUND COLOURS

    def bg_red
      "\e[48;5;1m#{self}\e[0m"
    end

    def bg_blue
      "\e[48;5;4m#{self}\e[0m"
    end

    def bg_aqua
      "\e[48;5;6m#{self}\e[0m"
    end

    def bg_yellow
      "\e[48;5;3m#{self}\e[0m"
    end

    def bg_white
      "\e[48;5;7m#{self}\e[0m"
    end

    def bg_green
      "\e[48;5;2m#{self}\e[0m"
    end

    def bg_gray
      "\e[48;5;8m#{self}\e[0m"
    end

    def bg_black
      "\e[48;5;0m#{self}\e[0m"
    end

    def bg_violet
      "\e[48;5;5m#{self}\e[0m"
    end
  end

  module Styling
    def bold
      "\e[1m#{self}\e[22m"
    end

    def faint
      "\e[2m#{self}\e[22m"
    end

    def italic
      "\e[3m#{self}\e[23m"
    end

    def underline
      "\e[4m#{self}\e[24m"
    end

    def blink
      "\e[5m#{self}\e[25m"
    end

    def reverse
      "\e[7m#{self}\e[27m"
    end

    def hide
      "\e[8m#{self}\e[28m"
    end

    def strike
      "\e[9m#{self}\e[29m"
    end
  end

  module Formatting
    def strip_formatting!
      self.gsub!(/\033\[\d+(?:;\d+)*m/, '')
    end

    def formatted?
      !!(self =~ /\033\[\d+(?:;\d+)*m/)
    end

    def fill_width(width = default_width, padding = ' ')
      self.ljust(width, padding)
    end

    def width_to(width = default_width, padding = ' ')
      self.rjust(width, padding)
    end

    def sym_padding(padding = ' ', width = default_width)
      res = self.ljust(width / 2, padding)
      res.rjust(width / 2, padding)
    end

    private

    def default_width
      defined?(TTY::Screen) ? TTY::Screen.width : 80
    end
  end

  module DebugHelpers
    def is_gem?
      regex_pattern = /rubies|\/my_gems\/|\/gems\//
      !!(self.match(regex_pattern))
    end

    def format_trace
      str = self.dup

      str.scan(/([\/\w.-]+):\d+:in/).flatten.each do |path|
        split = str.split(":in")

        if split[0].to_s.stack_trace_highlighted?
          split[0] = split[0].bg_yellow.black
        elsif str.include?("/repo/")
          split[0].white.bg_blue
        else
          split[0] = split[0].gray
        end

        split[1] = split[1].purple.bold if split[1]

        str = split.join(":in")
        str.gsub!("/home/ruby/.rvm/rubies/ruby-2.7.3", "")
      end

      str
    end

    # Should be moved
    def indent
      " " * StackTracer.indent_value + self
    end

    def debug_indent
      " " * StackTracer.debug_indent_value + self
    end

    def should_be_listed_in_trace?
      BetterTrace.should_be_included_in_trace?(self)
      # self.include?("/repo/") || self.stack_trace_highlighted?
    end

    def stack_trace_highlighted?
      BetterTrace.highlight_line?(self)
    end

    def coderay(language = :ruby)
      return unless defined?(CodeRay)

      CodeRay.scan(self, language).term
    end
  end

  include Colours
  include Styling
  include Formatting
  include DebugHelpers
end