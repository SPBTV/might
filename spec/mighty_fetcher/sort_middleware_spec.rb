require 'mighty_fetcher/sort_middleware'
require 'mighty_fetcher/sort_parameter'
require 'mighty_fetcher/sort_parameter_definition'
require 'set'
require 'database_helper'

RSpec.describe MightyFetcher::SortMiddleware do
  let(:params) { { sort: Set.new([parameter]) } }
  let(:parameter) { MightyFetcher::SortParameter.new('asc', parameters_definition) }
  let(:parameters_definition) { MightyFetcher::SortParameterDefinition.new('name') }

  def call_middleware(params)
    described_class.new(->(env) { env }).call([Page.all, params])
  end

  it 'returns sorted collection and not modified params' do
    scope, parameters = call_middleware(params)
    expect(scope.map(&:name)).to eq(['Page #0', 'Page #1', 'Page #2'])
    expect(parameters).to eq(params)
  end
end
