RSpec.describe Interaptor::Callbacks do

  describe 'before callback' do
    subject(:interactor) do
      build_interactor do
        attr_accessor :steps

        before do
          self.steps << 'before'
        end

        def initialize
          self.steps = []
        end

        def execute
          self.steps << 'execute'
        end
      end
    end

    before(:each) do
      interactor.call!
    end

    it 'before callback should be executed before execute method' do
      expect(interactor.steps).to match ['before', 'execute']
    end
  end

  describe 'after callback' do
    subject(:interactor) do
      build_interactor do
        attr_accessor :steps

        after do
          self.steps << 'after'
        end

        def initialize
          self.steps = []
        end

        def execute
          self.steps << 'execute'
        end
      end
    end

    before(:each) do
      interactor.call!
    end

    it 'after callback should be executed after execute method' do
      expect(interactor.steps).to match ['execute', 'after']
    end
  end

end
