require "interaptor/version"
require "interaptor/result"
require "interaptor/failure"
require "interaptor/error"
require "interaptor/callbacks"

module Interaptor

  def self.included(base)
    base.class_eval do
      include Callbacks
    end
  end

  def call(*params)
    begin
      value = call!(*params)

      if @result && !@result.success?
        return Interaptor::Result.new(errors: @result.errors)
      end

      return Interaptor::Result.new.tap do |result|
        result.value = value
      end
    rescue Interaptor::Failure => e
      return Interaptor::Result.new(errors: e.errors)
    end

  end

  def call!(*params)
    run_before_callbacks
    value = execute(*params)
    run_after_callbacks

    return value
  end

  def add_error(message, source: nil)
    @result ||= Interaptor::Result.new
    @result.add_error(Interaptor::Error.new(message, source))
  end

  def fail!(message=nil, source: nil)
    add_error(message, source: source) if message

    raise 'You cannot call fail! with empty errors!' if @result.nil? || @result.errors.empty?

    raise Interaptor::Failure.new(@result ? @result.errors : [])
  end

end
