require 'mighty_fetcher/sort/parameters_validator'
require 'mighty_fetcher/sort/parameter'
require 'mighty_fetcher/sort/parameter_definition'
require 'mighty_fetcher/sort/undefined_parameter'

RSpec.describe MightyFetcher::Sort::ParametersValidator do
  let(:validator) do
    app = ->(env) { env[1] }
    described_class.new(app)
  end

  def validate!(sort_order)
    validator.call([nil, [sort_order]])
  end

  context 'when not allowed sort order given' do
    let(:definition) { MightyFetcher::Sort::UndefinedParameter.new(:name) }
    let(:sort_order) { MightyFetcher::Sort::Parameter.new('asc', definition) }

    it 'fails with error' do
      expect do
        validate!(sort_order)
      end.to raise_error(MightyFetcher::SortOrderValidationFailed)
    end
  end

  context 'when allowed sort order given' do
    let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name) }
    let(:sort_order) { MightyFetcher::Sort::Parameter.new('asc', definition) }

    it 'fails with error' do
      expect do
        validate!(sort_order)
      end.not_to raise_error
    end
  end
end
