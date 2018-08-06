# frozen_string_literal: true
RSpec.describe Might::Fetcher, 'Sort DSL' do
  let(:fetcher_class) do
    Class.new(described_class)
  end

  before do
    fetcher_class.sort_parameters_definition = Set.new
  end

  context '#sort' do
    subject { fetcher_class.sort_parameters_definition }

    context 'add sortable property' do
      let(:property) do
        Might::SortParameterDefinition.new(:foo)
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
        Might::SortParameterDefinition.new(:foo, as: :bar)
      end

      before do
        fetcher_class.sort :foo, as: :bar
      end

      it 'add property' do
        is_expected.to include(property)
      end
    end

    context 'add sortable property with and without an alias' do
      before do
        fetcher_class.sort :foo
        fetcher_class.sort :foo, as: :bar
      end

      it do
        is_expected
          .to include(Might::SortParameterDefinition.new(:foo), Might::SortParameterDefinition.new(:foo, as: :bar))
      end
    end

    context 'add sortable property with :reverse' do
      let(:property) do
        Might::SortParameterDefinition.new(:foo, reverse_direction: true)
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
        Might::SortParameterDefinition.new(:foo)
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
