RSpec.describe Interaptor do

  it "has a version number" do
    expect(Interaptor::VERSION).not_to be nil
  end

  describe 'call' do

    describe 'success' do
      subject(:interactor) do
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
      subject(:interactor) do
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
      subject(:interactor) do
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


  describe 'call!' do

    describe 'success' do
      subject(:interactor) do
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

    describe 'single fail! call' do
      subject(:interactor) do
        build_interactor do
          def execute
            fail!('Some error here', source: :something)
          end
        end
      end

      it 'should raise an exception with one error' do
        expect { interactor.call! }.to raise_error do |failure|
          expect(failure).to be_a Interaptor::Failure
          expect(failure.errors).not_to be_empty
          expect(failure.errors.size).to eq 1
          expect(failure.errors.first.message).to eq 'Some error here'
          expect(failure.errors.first.source).to eq :something
        end
      end
    end

    describe 'multiple add_error with empty fail! call' do
      subject(:interactor) do
        build_interactor do
          def execute
            add_error('Some error here', source: :something)
            add_error('Some second error here', source: :another)

            fail!
          end
        end
      end

      it 'should raise an exception with two errors' do
        expect { interactor.call! }.to raise_error do |failure|
          expect(failure).to be_a Interaptor::Failure
          expect(failure.errors).not_to be_empty
          expect(failure.errors.size).to eq 2
          expect(failure.errors.first.message).to eq 'Some error here'
          expect(failure.errors.first.source).to eq :something
          expect(failure.errors.last.message).to eq 'Some second error here'
          expect(failure.errors.last.source).to eq :another
        end
      end
    end
  end

end
