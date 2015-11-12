require 'mighty_fetcher/sort/parameter_definition'

RSpec.describe MightyFetcher::Sort::ParameterDefinition do
  context '#as' do
    context 'when :as option given' do
      subject { described_class.new(:foo, as: :bar).as }

      it 'equals to passed value' do
        is_expected.to eq('bar')
      end
    end

    context 'when :as option not given' do
      subject { described_class.new(:foo).as }

      it 'equals to name value' do
        is_expected.to eq('foo')
      end
    end
  end

  context '#reverse_direction' do
    context 'when :reverse_direction option given and true' do
      subject { described_class.new(:foo, reverse_direction: true).reverse_direction }

      it 'equals to passed value' do
        is_expected.to eq(true)
      end
    end

    context 'when :reverse_direction option given and false' do
      subject { described_class.new(:foo, reverse_direction: false).reverse_direction }

      it 'equals to name value' do
        is_expected.to eq(false)
      end
    end

    context 'when :reverse_direction option not given' do
      subject { described_class.new(:foo).reverse_direction }

      it 'equals to name value' do
        is_expected.to eq(false)
      end
    end
  end
end
