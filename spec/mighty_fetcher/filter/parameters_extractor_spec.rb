require 'set'
require 'mighty_fetcher/filter/parameters_extractor'
require 'mighty_fetcher/filter/predicates'
require 'mighty_fetcher/filter/parameter_definition'
require 'mighty_fetcher/filter/parameter'

RSpec.describe MightyFetcher::Filter::ParametersExtractor do
  context '#call' do
    # @param parameters_definition [MightyFetcher::Filter::ParameterDefinition]
    def extractor(parameters_definition)
      app = ->(env) { env[1] }
      described_class.new(app, Set.new([parameters_definition]))
    end

    shared_examples 'predicate for value' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value' }
        let(:parameter_definition) { MightyFetcher::Filter::ParameterDefinition.new(attribute) }

        subject do
          extractor(parameter_definition).call([nil, { key => value }])
        end

        it 'returns ransackable params' do
          expected_parameter = MightyFetcher::Filter::Parameter.new(value, predicate, parameter_definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    shared_examples 'predicate for array' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value1,value2' }
        let(:parameter_definition) { MightyFetcher::Filter::ParameterDefinition.new(attribute) }

        subject do
          extractor(parameter_definition).call([nil, { key => 'value1,value2' }])
        end

        it 'returns ransackable params' do
          expected_parameter = MightyFetcher::Filter::Parameter.new(%w(value1 value2), predicate, parameter_definition)
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
      let(:parameter_definition) { MightyFetcher::Filter::ParameterDefinition.new(attribute) }

      subject(:filters) do
        extractor(parameter_definition).call([nil, {}])
      end

      it 'returns ransackable params' do
        expected_parameter = MightyFetcher::Filter::Parameter.new(nil, nil, parameter_definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end

    context 'when parameter with alias given' do
      let(:name) { :name }
      let(:aliased) { :title }
      let(:predicate) { 'eq' }
      let(:parameter_definition) { MightyFetcher::Filter::ParameterDefinition.new(name, as: aliased) }

      subject do
        extractor(parameter_definition).call([nil, {"#{aliased}_#{predicate}" => 'foo'}])
      end

      it 'returns ransackable params' do
        expected_parameter = MightyFetcher::Filter::Parameter.new('foo', 'eq', parameter_definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end
  end
end
