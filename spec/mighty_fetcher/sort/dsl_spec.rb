require 'set'
require 'mighty_fetcher/sort/dsl'
require 'mighty_fetcher/sort/parameter_definition'

RSpec.describe MightyFetcher::Sort::DSL do
  let(:fetcher_class) do
    Class.new do
      extend MightyFetcher::Sort::DSL
    end
  end

  before do
    fetcher_class.instance_variable_set(:@sort_parameters_definition, Set.new)
  end

  context '#sort' do
    subject { fetcher_class.sort_parameters_definition }

    context 'add sortable property' do
      let(:property) do
        MightyFetcher::Sort::ParameterDefinition.new(:foo)
      end

      before do
        fetcher_class.sort :foo
      end

      it 'add property' do
        is_expected.to include(property)
      end
    end

    context 'add sortable property with :as' do
      let(:property) do
        MightyFetcher::Sort::ParameterDefinition.new(:foo, as: :bar)
      end

      before do
        fetcher_class.sort :foo, as: :bar
      end

      it 'add property' do
        is_expected.to include(property)
      end
    end

    context 'add sortable property with :reverse' do
      let(:property) do
        MightyFetcher::Sort::ParameterDefinition.new(:foo, reverse_direction: true)
      end

      before do
        fetcher_class.sort :foo, reverse_direction: true
      end

      it 'add property' do
        is_expected.to include(property)
      end
    end

    context 'add the same sortable property twice' do
      let(:property) do
        MightyFetcher::Sort::ParameterDefinition.new(:foo)
      end

      before do
        fetcher_class.sort :foo
        fetcher_class.sort 'foo'
      end

      it 'add property' do
        is_expected.to include(property)
      end
    end
  end
end
