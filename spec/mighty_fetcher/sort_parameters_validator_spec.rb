require 'mighty_fetcher/sort_parameters_validator'
require 'mighty_fetcher/sort_parameter'
require 'mighty_fetcher/sort_parameter_definition'
require 'mighty_fetcher/sort_undefined_parameter'

RSpec.describe MightyFetcher::SortParametersValidator do
  let(:validator) do
    app = ->(env) { env[1] }
    described_class.new(app)
  end

  def validate!(sort_order)
    validator.call([nil, [sort_order]])
  end

  context 'when not allowed sort order given' do
    let(:definition) { MightyFetcher::SortUndefinedParameter.new(:name) }
    let(:sort_order) { MightyFetcher::SortParameter.new('asc', definition) }

    it 'fails with error' do
      expect do
        validate!(sort_order)
      end.to raise_error(MightyFetcher::SortOrderValidationFailed)
    end
  end

  context 'when allowed sort order given' do
    let(:definition) { MightyFetcher::SortParameterDefinition.new(:name) }
    let(:sort_order) { MightyFetcher::SortParameter.new('asc', definition) }

    it 'fails with error' do
      expect do
        validate!(sort_order)
      end.not_to raise_error
    end
  end
end
