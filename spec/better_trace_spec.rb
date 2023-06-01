# frozen_string_literal: true

RSpec.describe BetterTrace do
  it "has a version number" do
    expect(BetterTrace::VERSION).not_to be nil
  end

  it "logs rescued exceptions" do
    with_rescue do
      BindingGenerator.new.broken
    end
  ensure
    expect(1).to eq(BetterTrace.logged_exceptions.size)
  end

  it "can rebuild frames from bindings" do
    b = BindingGenerator.bind
    b.eval('foo = "bar"')
    b.instance_variable_set(:@foo, "bar")
    frame = BetterTrace::TraceStack::Frame.new(b, caller_locations)

    expect(frame.local_vars[:foo]).to eq("bar")
    expect(frame.i_vars[:@foo]).to eql("bar")
  end
end
