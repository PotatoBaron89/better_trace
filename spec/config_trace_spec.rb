# frozen_string_literal: true

RSpec.describe BetterTrace do
  it "has configurable fields" do
    puts 'h'
    # BetterTrace.config.reject
    expect(BetterTrace::VERSION).not_to be nil
  end

end
