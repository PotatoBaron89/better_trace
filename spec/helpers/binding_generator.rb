class BindingGenerator

  def initialize
    unless block_given?
      @foo ||= generate { puts "Do the thing foo" }
    else
      @foo = generate { yield }
    end
  end

  def broken
    foo * bar
  end

  def self.bind
    new { puts "Hello World" }.__binding__
  end
  def generate
    data = ComplicatedData.new("foo lives here")
    foo_bar(data) { yield }
  end

  def foo_bar(data)
    var_1 = 'foo likes ' + foo
    data.the_data += "bar likes " + var_1

    data
  end

  def foo
    var_two = 'carrot' + bar
    var_two
  end

  def bar
    var_three = 'cake'
    var_three
  end

  class ComplicatedData
    attr_accessor :the_data
    def initialize(data)
      @the_data = data
    end
  end
end
