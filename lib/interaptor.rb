require "interaptor/version"
require "interaptor/result"
require "interaptor/failure"
require "interaptor/error"

module Interaptor

  def call(*params)
    begin
      value = call!(*params)

      if @result && !@result.success?
        return Interaptor::Result.new(success: false, errors: @result.errors)
      end

      return Interaptor::Result.new.tap do |result|
        result.value = value
      end
    rescue Interaptor::Failure => e
      return Interaptor::Result.new(success: false, errors: e.errors)
    end

  end

  def call!(*params)
    value = execute(*params)

    return value
  end

  def add_error(message, source: nil)
    @result ||= Interaptor::Result.new(success: false)
    @result.add_error(Interaptor::Error.new(message, source))
  end

  def fail!(message=nil, source: nil)
    add_error(message, source: source) if message

    raise Interaptor::Failure.new(@result ? @result.errors : [])
  end

end
