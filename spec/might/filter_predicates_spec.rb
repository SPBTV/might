require 'might/filter_predicates'

RSpec.describe Might::FilterPredicates do
  describe '.register' do
    context 'predicate on value' do
      let(:predicate) { 'is_upper_case' }

      before do
        described_class.register(predicate, on: :value)
      end

      context 'predicates for array' do
        subject do
          described_class.array
        end

        it { is_expected.not_to include(predicate) }
      end

      context 'predicates for value' do
        subject do
          described_class.value
        end

        it { is_expected.to include(predicate) }
      end

      context 'all predicates' do
        subject do
          described_class.all
        end

        it { is_expected.to include(predicate) }
      end
    end

    context 'predicate on array' do
      let(:predicate) { 'includes' }

      before do
        described_class.register(predicate, on: :array)
      end

      context 'predicates for array' do
        subject do
          described_class.array
        end

        it { is_expected.to include(predicate) }
      end

      context 'predicates for value' do
        subject do
          described_class.value
        end

        it { is_expected.not_to include(predicate) }
      end

      context 'all predicates' do
        subject do
          described_class.all
        end

        it { is_expected.to include(predicate) }
      end
    end
  end
end
