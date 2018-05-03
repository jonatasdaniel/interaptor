require "bundler/setup"
require "interaptor"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def build_interactor(&block)
  interactor = Class.new
  interactor.send(:include, Interaptor)
  interactor.class_eval(&block) if block
  interactor.new
end
