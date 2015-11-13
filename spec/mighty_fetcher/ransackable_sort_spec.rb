require 'mighty_fetcher/ransackable_sort'
require 'database_helper'

RSpec.describe MightyFetcher::RansackableSort do
  let(:pages) { Page.all }

  def call_middleware(params)
    described_class.new(->(env) { env }).call([pages, params])
  end

  it 'sort using ransack' do
    scope, _ = call_middleware(['name asc'])
    expect(scope.map(&:name)).to eq(['Page #0', 'Page #1', 'Page #2'])
  end
end
