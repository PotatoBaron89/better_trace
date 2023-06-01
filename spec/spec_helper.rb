# frozen_string_literal: true

require "better_trace"
require_relative 'helpers/binding_generator'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def with_default_exception
  BetterTrace.exception_override_disabled { yield }
end

def with_rescue(raise: false, without_override: true)
  begin
    BetterTrace.exception_override_disabled { yield }
  rescue StandardError => e
    raise e if raise
    nil
  end
end
