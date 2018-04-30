RSpec.describe Interaptor do

  def build_interactor(&block)
    interactor = Class.new
    interactor.send(:include, Interaptor)
    interactor.class_eval(&block) if block
    interactor.new
  end

  it "has a version number" do
    expect(Interaptor::VERSION).not_to be nil
  end

  describe 'call' do

    describe 'success' do
      let(:interactor) do
        build_interactor do
          def execute
            return "Yay!"
          end
        end
      end

      let(:result) { interactor.call }

      it 'should be success' do
        expect(result).to be_success
      end

      it 'should return result object with string' do
        expect(result.value).to eq 'Yay!'
      end

      it 'should not have errors' do
        expect(result.errors).to be_empty
      end
    end

    describe 'failure without return' do
      let(:interactor) do
        build_interactor do
          def execute
            add_error('Something went wrong!', source: :something)
            add_error('Something went wrong again!', source: :something)
          end
        end
      end

      let(:result) { interactor.call }

      it 'should not be success' do
        expect(result).not_to be_success
      end

      it 'should have two errors' do
        expect(result.errors).not_to be_empty
        expect(result.errors.size).to eq 2
        expect(result.errors.first.message).to eq 'Something went wrong!'
        expect(result.errors.first.source).to eq :something
        expect(result.errors.last.message).to eq 'Something went wrong again!'
        expect(result.errors.last.source).to eq :something
      end
    end

    describe 'failure with return' do
      let(:interactor) do
        build_interactor do
          attr_accessor :step
          def execute
            fail!('Something went wrong!', source: :something)
            fail!('Something went wrong again!', source: :something)
          end
        end
      end

      let(:result) { interactor.call }

      it 'should not be success' do
        expect(result).not_to be_success
      end

      it 'should have one error' do
        expect(result.errors).not_to be_empty
        expect(result.errors.size).to eq 1
        expect(result.errors.first.message).to eq 'Something went wrong!'
        expect(result.errors.first.source).to eq :something
      end
    end

  end



  describe 'call! success' do
    let(:interactor) do
      build_interactor do
        def execute
          return "Yay!"
        end
      end
    end

    let(:result) { interactor.call! }

    it 'should return result object with string' do
      expect(result).to eq 'Yay!'
    end

  end
end
