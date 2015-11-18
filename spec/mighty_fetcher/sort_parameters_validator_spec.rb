require 'mighty_fetcher/sort_parameters_validator'
require 'mighty_fetcher/sort_parameter'
require 'mighty_fetcher/sort_parameter_definition'
require 'mighty_fetcher/sort_undefined_parameter'

RSpec.describe MightyFetcher::SortParametersValidator do
  before :all do
    I18n.backend.store_translations(:en,
      activemodel: {
        errors: {
          messages: {
            undefined_sort_order: 'is not allowed sort order'
          }
        }
      }
    )
  end

  let(:errors) { ['The error'] }
  let(:validator) do
    app = ->(env) { env }
    described_class.new(app)
  end

  before do
    @processed_params, @processed_errors = validator.call([params, errors])
  end

  context 'when not allowed sort order given' do
    let(:definition) { MightyFetcher::SortUndefinedParameter.new(:name) }
    let(:params) { { sort: MightyFetcher::SortParameter.new('asc', definition) } }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'has errors' do
      expect(@processed_errors).to contain_exactly('The error', 'Name is not allowed sort order')
    end
  end

  context 'when allowed sort order given' do
    let(:definition) { MightyFetcher::SortParameterDefinition.new(:name) }
    let(:params) { { sort: MightyFetcher::SortParameter.new('asc', definition) } }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'has no errors' do
      expect(@processed_errors).to contain_exactly('The error')
    end
  end
end
