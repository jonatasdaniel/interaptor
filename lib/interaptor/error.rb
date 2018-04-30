class Interaptor::Error

  attr_accessor :message, :source

  def initialize(message, source)
    self.message, self.source = message, source
  end

end
