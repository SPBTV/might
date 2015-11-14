require 'mighty_fetcher/filter_middleware'
require 'mighty_fetcher/filter_parameter'
require 'mighty_fetcher/filter_parameter_definition'
require 'mighty_fetcher/validation_error'
require 'set'
require 'database_helper'

RSpec.describe MightyFetcher::FilterMiddleware do
  let(:params) { { filter: Set.new([parameter]) } }
  let(:page) { Page.first }
  let(:parameter) { MightyFetcher::FilterParameter.new(page.name, 'eq', definition) }
  let(:definition) do
    MightyFetcher::FilterParameterDefinition.new(:name, validates: { presence: true })
  end

  def call_middleware(params)
    described_class.new(->(env) { env }).call([Page.all, params])
  end

  it 'returns filtered collection and not modified params' do
    scope, parameters = call_middleware(params)
    expect(scope).to contain_exactly(page)
    expect(parameters).to eq(filter: { 'name_eq' => page.name })
  end
end
