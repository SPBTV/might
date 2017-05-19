# frozen_string_literal: true
require 'database_helper'

RSpec.describe Might::SortMiddleware, database: true do
  let(:params) { { sort: Set.new([parameter]) } }
  let(:parameter) { Might::SortParameter.new('asc', parameters_definition) }
  let(:parameters_definition) { Might::SortParameterDefinition.new('name') }

  def call_middleware(params)
    described_class.new(->(env) { env }).call([Page.all, params])
  end

  it 'returns sorted collection and not modified params' do
    scope, parameters = call_middleware(params)
    expect(scope.map(&:name)).to eq(['Page #0', 'Page #1', 'Page #2'])
    expect(parameters).to eq(params)
  end

  context 'sort by dynamically evaluated criteria' do
    let(:params) do
      {
        sort: Set.new([parameter]),
        sort_by: 'slug',
      }
    end
    let(:parameters_definition) do
      Might::SortParameterDefinition.new(->(params) { params[:sort_by] }, as: 'name')
    end

    it 'returns sorted collection and not modified params' do
      scope, parameters = call_middleware(params)
      expect(scope.map(&:name)).to eq(['Page #2', 'Page #1', 'Page #0'])
      expect(parameters).to eq(params)
    end
  end
end
