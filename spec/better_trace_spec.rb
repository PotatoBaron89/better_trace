# frozen_string_literal: true

RSpec.describe BetterTrace do
  it "has a version number" do
    expect(BetterTrace::VERSION).not_to be nil
  end

  it "does something useful" do
    begin
      foo * bar
    rescue => e
      binding.irb
    end
  end
end
