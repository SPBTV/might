require 'might/filter_parameter_definition'

RSpec.describe Might::FilterParameterDefinition do
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

  context '#predicates' do
    def definition(options)
      described_class.new(:name, options)
    end

    subject { definition(options).predicates }

    context 'when no predicates given' do
      let(:options) { {} }

      it 'allow to use all predicates' do
        is_expected.to contain_exactly(*Might::FilterPredicates.all)
      end
    end

    context 'when predicates given' do
      let(:options) do
        {
          predicates: %w(in eq),
        }
      end

      it 'allow to use only given  predicates' do
        is_expected.to contain_exactly('in', 'eq')
      end
    end
  end

  context '#coerce' do
    let(:name) { 'the_name' }

    subject { definition.coerce('channels') }

    context 'when coercion defined' do
      let(:coerce) do
        ->(value) { value.classify }
      end

      let(:definition) { described_class.new(name, coerce: coerce) }

      it 'is coerced' do
        is_expected.to eq('Channel')
      end
    end

    context 'when coercion is not defined' do
      let(:definition) { described_class.new(name) }

      it 'is not coerced' do
        is_expected.to eq('channels')
      end
    end
  end
end
