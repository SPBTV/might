require 'might/paginator'
require 'database_helper'

RSpec.describe Might::Paginator do
  before :all do
    Schema.create
    5.times { |n| Page.create!(name: n) }
  end

  after :all do
    Page.delete_all
  end

  context 'valid limit and offset' do
    subject(:paginated) { described_class.new(limit: 2, offset: 4).paginate(Page.all) }

    it 'contains requested elements' do
      expect(paginated.pluck(:name)).to eq(['4'])
    end

    it 'set #pagination for collection' do
      expect(paginated.pagination).to include(
        limit: 2,
        offset: 4,
        count: 1,
        total: 5
      )
    end
  end

  context 'invalid limit and offset' do
    it 'fail with InvalidLimitOrOffset error if limit less then 0 ' do
      expect do
        described_class.new(limit: -2, offset: 4)
      end.to raise_error(Might::Paginator::InvalidLimitOrOffset)
    end

    it 'fail with InvalidLimitOrOffset error if offset less then 0 ' do
      expect do
        described_class.new(limit: 2, offset: -4)
      end.to raise_error(Might::Paginator::InvalidLimitOrOffset)
    end
  end

  specify 'no limit or offset' do
    expect { described_class.new(offset: 5) }.to raise_error(KeyError)
    expect { described_class.new(limit: 5) }.to raise_error(KeyError)
  end
end
