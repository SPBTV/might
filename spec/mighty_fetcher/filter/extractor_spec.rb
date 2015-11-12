require 'set'
require 'mighty_fetcher/filter/predicates'
require 'mighty_fetcher/filter/extractor'
require 'mighty_fetcher/filter/parameter_definition'
require 'mighty_fetcher/filter/parameter'

RSpec.describe MightyFetcher::Filter::Extractor do
  context '#call' do
    shared_examples 'predicate for value' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value' }
        let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(attribute) }

        subject do
          described_class.new({ filter: { key => value } }, Set.new([definition])).call
        end

        it 'returns ransackable params' do
          expected_parameter = MightyFetcher::Filter::Parameter.new(value, predicate, definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    shared_examples 'predicate for array' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value1,value2' }
        let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(attribute) }

        subject do
          described_class.new({ filter: { key => 'value1,value2' } }, Set.new([definition])).call
        end

        it 'returns ransackable params' do
          expected_parameter = MightyFetcher::Filter::Parameter.new(%w(value1 value2), predicate, definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    MightyFetcher::Filter::Predicates::ON_VALUE.each do |predicate|
      include_examples 'predicate for value', predicate
    end

    MightyFetcher::Filter::Predicates::ON_ARRAY.each do |predicate|
      include_examples 'predicate for array', predicate
    end

    context 'when parameter is not given' do
      let(:attribute) { 'test' }
      let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(attribute) }

      subject do
        described_class.new({ filter: {} }, Set.new([definition])).call
      end

      it 'returns ransackable params' do
        expected_parameter = MightyFetcher::Filter::Parameter.new(nil, nil, definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end

    context 'when parameter with alias given' do
      let(:name) { :name }
      let(:aliased) { :title }
      let(:predicate) { 'eq' }
      let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(name, as: aliased) }
      let(:definitions) { Set.new([definition]) }

      subject do
        described_class.new({ filter: { "#{aliased}_#{predicate}" => 'foo' } }, definitions).call
      end

      it 'returns ransackable params' do
        expected_parameter = MightyFetcher::Filter::Parameter.new('foo', 'eq', definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end
  end
end
