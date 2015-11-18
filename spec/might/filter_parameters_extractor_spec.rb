require 'set'
require 'might/filter_parameters_extractor'
require 'might/filter_predicates'
require 'might/filter_parameter_definition'
require 'might/filter_parameter'

RSpec.describe Might::FilterParametersExtractor do
  context '#call' do
    # @param parameters_definition [Might::FilterParameterDefinition]
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
        let(:parameter_definition) { Might::FilterParameterDefinition.new(attribute) }
        let(:params) { { filter: { key => value } } }

        subject do
          extract(parameter_definition, params)
        end

        it 'returns ransackable params' do
          expected_parameter = Might::FilterParameter.new(value, predicate, parameter_definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    shared_examples 'predicate for array' do |predicate|
      context "when predicate #{predicate} given" do
        let(:attribute) { 'test' }
        let(:key) { "#{attribute}_#{predicate}" }
        let(:value) { 'value1,value2' }
        let(:parameter_definition) { Might::FilterParameterDefinition.new(attribute) }
        let(:params) { { filter: { key => 'value1,value2' } } }

        subject do
          extract(parameter_definition, params)
        end

        it 'returns ransackable params' do
          expected_parameter = Might::FilterParameter.new(%w(value1 value2), predicate, parameter_definition)
          is_expected.to contain_exactly(expected_parameter)
        end
      end
    end

    Might::FilterPredicates::ON_VALUE.each do |predicate|
      include_examples 'predicate for value', predicate
    end

    Might::FilterPredicates::ON_ARRAY.each do |predicate|
      include_examples 'predicate for array', predicate
    end

    context 'when parameter is not given' do
      let(:attribute) { 'test' }
      let(:parameter_definition) { Might::FilterParameterDefinition.new(attribute) }
      let(:params) { {} }

      subject(:filters) do
        extract(parameter_definition, params)
      end

      it 'returns ransackable params' do
        expected_parameter = Might::FilterParameter.new(nil, nil, parameter_definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end

    context 'when parameter with alias given' do
      let(:name) { :name }
      let(:aliased) { :title }
      let(:predicate) { 'eq' }
      let(:parameter_definition) { Might::FilterParameterDefinition.new(name, as: aliased) }
      let(:params) { { filter: { "#{aliased}_#{predicate}" => 'foo' } } }

      subject do
        extract(parameter_definition, params)
      end

      it 'returns ransackable params' do
        expected_parameter = Might::FilterParameter.new('foo', 'eq', parameter_definition)
        is_expected.to contain_exactly(expected_parameter)
      end
    end
  end
end
