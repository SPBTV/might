require 'set'
require 'might/fetcher'
require 'might/filter_parameter_definition'

RSpec.describe Might::Fetcher, 'Filter DSL' do
  describe '.filter' do
    let(:fetcher_class) do
      Class.new(described_class)
    end

    before do
      fetcher_class.filter_parameters_definition = Set.new
    end

    subject { fetcher_class.filter_parameters_definition }

    context 'add filter without predicates' do
      let(:filter) do
        Might::FilterParameterDefinition.new(:title, validates: { presence: true })
      end

      before do
        fetcher_class.filter :title, validates: { presence: true }
      end

      it 'add filter' do
        is_expected.to include(filter)
      end
    end

    context 'add filter with white-listed predicates' do
      let(:filter) do
        Might::FilterParameterDefinition.new(:title, predicates: [:eq], validates: { presence: true })
      end

      before do
        fetcher_class.filter title: :eq, validates: { presence: true }
      end

      it 'add filter' do
        is_expected.to include(filter)
      end
    end

    context 'add filter property with :as' do
      let(:property) do
        Might::FilterParameterDefinition.new(:foo, as: :bar)
      end

      before do
        fetcher_class.filter :foo, as: :bar
      end

      it 'add property' do
        is_expected.to include(property)
      end
    end
  end
end
