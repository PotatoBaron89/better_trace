

module BetterTrace
  module Output
    extend BetterTrace

    module_function

    def format_line(line)
      puts "  #{line}".blue
    end
  end
end