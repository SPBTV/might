require 'mighty_fetcher/filter/parameters_validator'
require 'mighty_fetcher/filter/parameter'
require 'mighty_fetcher/filter/parameter_definition'

RSpec.describe MightyFetcher::Filter::ParametersValidator do
  let(:validator) do
    app = ->(env) { env[1] }
    described_class.new(app)
  end

  context 'when some filter is required' do
    let(:definition) do
      MightyFetcher::Filter::ParameterDefinition.new(:name, validates: { presence: true })
    end
    def validate!(filter)
      validator.call([nil, [filter]])
    end

    context 'and it is not given' do
      let(:filter) { MightyFetcher::Filter::Parameter.new(nil, nil, definition) }

      it 'fails with error' do
        expect do
          validate!(filter)
        end.to raise_error(MightyFetcher::FilterValidationFailed)
      end
    end

    context 'and it is given' do
      let(:filter) { MightyFetcher::Filter::Parameter.new('Bob', 'eq', definition) }

      it 'return found objects' do
        expect do
          validate!(filter)
        end.not_to raise_error
      end
    end
  end
end
