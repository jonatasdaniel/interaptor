module Interaptor

  module Callbacks

    def self.included(base)
      base.extend(ClassMethods)
    end

    def run_callback(callback, *args)
      if callback.is_a?(Symbol)
      else
        instance_exec(*args, &callback)
      end
    end

    def run_before_callbacks
      self.class.before_callbacks.each { |callback| run_callback(callback) }
    end

    def run_after_callbacks
      self.class.after_callbacks.each { |callback| run_callback(callback) }
    end

  end

  module ClassMethods

    def before(&block)
      before_callbacks << block
    end

    def after(&block)
      after_callbacks << block
    end

    def before_callbacks
      @before_callbacks ||= []
    end

    def after_callbacks
      @after_callbacks ||= []
    end
  end

end
