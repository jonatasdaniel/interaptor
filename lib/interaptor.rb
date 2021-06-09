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
        result = Interaptor::Result.new(errors: @result.errors)
      else
        result = Interaptor::Result.new.tap do |result|
          result.value = value
        end
      end
      block_given? ? yield(result) : result
    rescue Interaptor::Failure => e
      result = Interaptor::Result.new(errors: e.errors)
      block_given? ? yield(result) : result
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

    raise StandardError, 'You cannot call fail! with empty errors!' if @result.nil? || @result.errors.empty?

    raise Interaptor::Failure.new(@result ? @result.errors : [])
  end

end
