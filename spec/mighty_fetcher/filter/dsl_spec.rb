require 'set'
require 'mighty_fetcher/filter/dsl'
require 'mighty_fetcher/filter/parameter_definition'

RSpec.describe MightyFetcher::Filter::DSL do
  let(:fetcher_class) do
    Class.new do
      include MightyFetcher::Filter::DSL
    end
  end

  before do
    fetcher_class.instance_variable_set(:@filter_parameters_definition, Set.new)
  end

  subject { fetcher_class.filter_parameters_definition }

  context 'add filter without predicates' do
    let(:filter) do
      MightyFetcher::Filter::ParameterDefinition.new(:title, validates: { presence: true })
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
      MightyFetcher::Filter::ParameterDefinition.new(:title, predicates: [:eq], validates: { presence: true })
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
      MightyFetcher::Filter::ParameterDefinition.new(:foo, as: :bar)
    end

    before do
      fetcher_class.filter :foo, as: :bar
    end

    it 'add property' do
      is_expected.to include(property)
    end
  end
end
