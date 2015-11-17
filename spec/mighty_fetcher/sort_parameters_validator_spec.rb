require 'mighty_fetcher/sort_parameters_validator'
require 'mighty_fetcher/sort_parameter'
require 'mighty_fetcher/sort_parameter_definition'
require 'mighty_fetcher/sort_undefined_parameter'

RSpec.describe MightyFetcher::SortParametersValidator do
  let(:validator) do
    app = ->(env) { env[0] }
    described_class.new(app)
  end

  def validate!(params)
    validator.call([params, nil])
  end

  context 'when not allowed sort order given' do
    let(:definition) { MightyFetcher::SortUndefinedParameter.new(:name) }
    let(:params) { { sort: MightyFetcher::SortParameter.new('asc', definition) } }

    it 'fails with error' do
      expect do
        validate!(params)
      end.to raise_error(MightyFetcher::SortOrderValidationFailed)
    end
  end

  context 'when allowed sort order given' do
    let(:definition) { MightyFetcher::SortParameterDefinition.new(:name) }
    let(:params) { { sort: MightyFetcher::SortParameter.new('asc', definition) } }

    it 'fails with error' do
      expect do
        validate!(params)
      end.not_to raise_error
    end
  end
end
