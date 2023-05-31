# frozen_string_literal: true

class RescuedException

  attr_accessor :exception, :error_klass, :path, :trace, :is_rescued

  def initialize(exception, path, trace, is_rescued: false)
    @exception = exception
    @error_klass = exception.class
    @path = path
    @trace = trace
    @is_rescued = is_rescued
  end
end