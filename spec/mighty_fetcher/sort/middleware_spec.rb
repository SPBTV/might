require 'mighty_fetcher/sort/middleware'
require 'mighty_fetcher/sort/parameter_definition'
require 'database_helper'

RSpec.describe MightyFetcher::Sort::Middleware do
  before do
    2.downto(0).each do |n|
      Page.create(name: n)
    end
  end
  let(:pages) { Page.all }

  let(:parameters_definition) do
    [MightyFetcher::Sort::ParameterDefinition.new('name')]
  end

  def call_middleware(parameters_definition, params)
    described_class.new(->(env) { env }, parameters_definition).call([pages, params])
  end

  context 'when not allowed sorting given' do
    let(:params) { { sort: '-not_allowed1,name,not_allowed2' } }

    it 'raise SortingNotAllowed error' do
      expect do
        call_middleware(parameters_definition, params)
      end.to raise_error(MightyFetcher::SortOrderValidationFailed)
    end
  end

  context 'when one of sorting given' do
    let(:params) { { sort: 'name' } }

    it 'returns sorted collection and not modified params' do
      scope, parameters = call_middleware(parameters_definition, params)
      expect(scope.map(&:name)).to eq(%w(0 1 2))
      expect(parameters).to eq(params)
    end
  end
end
