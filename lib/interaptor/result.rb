class Interaptor::Result

  attr_accessor :value

  def initialize(success: true, errors: [])
    @success = success
    @errors = errors
  end

  def errors
    @errors || []
  end

  def success?
    @success && @errors.empty?
  end

  def add_error(error)
    success = false
    @errors ||= []
    @errors << error
  end

end
