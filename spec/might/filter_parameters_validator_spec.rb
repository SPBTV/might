require 'might/filter_parameters_validator'
require 'might/filter_parameter'
require 'might/filter_parameter_definition'

RSpec.describe Might::FilterParametersValidator do
  let(:validator) do
    app = ->(env) { env }
    described_class.new(app)
  end

  before :all do
    I18n.backend.store_translations(:en,
      activemodel: {
        errors: {
          messages: {
            blank: 'should not be blank'
          }
        }
      }
    )
  end

  context 'when some filter is required' do
    let(:definition) { Might::FilterParameterDefinition.new(:name, validates: { presence: true }) }
    let(:params) { { filter: [filter] } }
    let(:errors) { ['The error'] }

    before do
      @processed_params, @processed_errors = validator.call([params, errors])
    end

    context 'and it is not given' do
      let(:filter) { Might::FilterParameter.new(nil, nil, definition) }

      it 'leaves params unchanged' do
        expect(@processed_params).to eq(params)
      end

      it 'has errors' do
        expect(@processed_errors).to contain_exactly('The error', 'Name should not be blank')
      end
    end

    context 'and it is given' do
      let(:filter) { Might::FilterParameter.new('Bob', 'eq', definition) }

      it 'leaves params unchanged' do
        expect(@processed_params).to eq(params)
      end

      it 'has no errors' do
        expect(@processed_errors).to contain_exactly('The error')
      end
    end
  end
end
