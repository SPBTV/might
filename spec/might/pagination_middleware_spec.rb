require 'might/pagination_middleware'
require 'database_helper'

RSpec.describe Might::PaginationMiddleware do
  before :all do
    Schema.create
    5.times { |n| Page.create!(name: n) }
  end

  after :all do
    Page.delete_all
  end

  def call_middleware(params)
    described_class
      .new(->(env) { env }, per_page: 3, max_per_page: 4)
      .call([Page, params])
  end

  before do
    @processed_scopes, @processed_params = call_middleware(params)
  end

  context 'when :page options given' do
    let(:params) do
      {
        'page' => {
          'limit' => 2,
          'offset' => 4
        }
      }.with_indifferent_access
    end

    it 'instantiate the paginator' do
      expect(@processed_scopes.map(&:name)).to eq(['4'])
    end

    it 'leave params unchanged' do
      expect(@processed_params).to eq(params)
    end
  end
end
