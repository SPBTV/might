require 'might/filter_middleware'
require 'might/filter_parameter'
require 'might/filter_parameter_definition'
require 'might/filter_parameters'
require 'database_helper'

RSpec.describe Might::FilterMiddleware, database: true do
  let(:params) { { filter: Might::FilterParameters.new([parameter]) } }
  let(:page) { Page.first }
  let(:parameter) { Might::FilterParameter.new(page.name, 'eq', definition) }
  let(:definition) do
    Might::FilterParameterDefinition.new(:name, validates: { presence: true })
  end

  def call_middleware(params)
    described_class.new(->(env) { env }).call([Page.all, params])
  end

  it 'returns filtered collection and not modified params' do
    scope, parameters = call_middleware(params)
    expect(scope).to contain_exactly(page)
    expect(parameters).to eq(params)
  end
end
