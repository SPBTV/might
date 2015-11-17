require 'set'
require 'mighty_fetcher/filter_parameters_extractor'
require 'mighty_fetcher/filter_predicates'
require 'mighty_fetcher/filter_parameter_definition'
require 'mighty_fetcher/filter_parameter'

RSpec.describe MightyFetcher::FilterParametersExtractor do
  context '#call' do
    # @param parameters_definition [MightyFetcher::FilterParameterDefinition]
    def extractor(parameters_definition)
      app = ->(env) { env[0] }
      described_class.new(app, Set.new([parameters_definition]))
    end

    def extract(parameter_definition, params)
      extractor(parameter_definition).call([params, nil])[:filter]
    end

    shared_examples 'predicate for value' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value' }
        let(:parameter_definition) { MightyFetcher::FilterParameterDefinition.new(attribute) }
        let(:params) { { filter: { key => value } } }

        subject do
          extract(parameter_definition, params)
        end

        it 'returns ransackable params' do
          expected_parameter = MightyFetcher::FilterParameter.new(value, predicate, parameter_definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    shared_examples 'predicate for array' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value1,value2' }
        let(:parameter_definition) { MightyFetcher::FilterParameterDefinition.new(attribute) }
        let(:params) { { filter: { key => 'value1,value2' } } }

        subject do
          extract(parameter_definition, params)
        end

        it 'returns ransackable params' do
          expected_parameter = MightyFetcher::FilterParameter.new(%w(value1 value2), predicate, parameter_definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    MightyFetcher::FilterPredicates::ON_VALUE.each do |predicate|
      include_examples 'predicate for value', predicate
    end

    MightyFetcher::FilterPredicates::ON_ARRAY.each do |predicate|
      include_examples 'predicate for array', predicate
    end

    context 'when parameter is not given' do
      let(:attribute) { 'test' }
      let(:parameter_definition) { MightyFetcher::FilterParameterDefinition.new(attribute) }
      let(:params) { {} }

      subject(:filters) do
        extract(parameter_definition, params)
      end

      it 'returns ransackable params' do
        expected_parameter = MightyFetcher::FilterParameter.new(nil, nil, parameter_definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end

    context 'when parameter with alias given' do
      let(:name) { :name }
      let(:aliased) { :title }
      let(:predicate) { 'eq' }
      let(:parameter_definition) { MightyFetcher::FilterParameterDefinition.new(name, as: aliased) }
      let(:params) {  { filter: {"#{aliased}_#{predicate}" => 'foo'} } }

      subject do
        extract(parameter_definition, params)
      end

      it 'returns ransackable params' do
        expected_parameter = MightyFetcher::FilterParameter.new('foo', 'eq', parameter_definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end
  end
end
