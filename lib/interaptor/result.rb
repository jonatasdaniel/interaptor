class Interaptor::Result

  attr_accessor :value

  def initialize(errors: [])
    @errors = errors
  end

  def errors
    @errors || []
  end

  def success?
    @errors.empty?
  end

  def add_error(error)
    @errors ||= []
    @errors << error
  end

end
