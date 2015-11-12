require 'mighty_fetcher/sort/ransackable/sort'
require 'database_helper'

RSpec.describe MightyFetcher::Sort::Ransackable::Sort do
  before do
    2.downto(0).each do |n|
      Page.create(name: n)
    end
  end
  let(:pages) { Page.all }

  def call_middleware(params)
    described_class.new(->(env) { env }).call([pages, params])
  end

  it 'sort using ransack' do
    scope, params = call_middleware(['name asc'])
    expect(scope.map(&:name)).to eq(%w(0 1 2))
  end
end
