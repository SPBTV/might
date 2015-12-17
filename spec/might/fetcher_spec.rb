require 'might/fetcher'

RSpec.describe Might::Fetcher do
  describe '#call' do
    let(:params) { double('params') }
    let(:collection) { double('collection') }
    let(:processed_collection) { double('processed_collection') }
    let(:fetcher) { fetcher_class(collection, processed_collection).new(params) }

    def fetcher_class(collection, processed_collection)
      klass = double('resource_class', all: collection)

      Class.new(described_class) do
        self.resource_class = klass
        define_method :fetch_middleware do
          ::Middleware::Builder.new do |b|
            b.use ->(_) { processed_collection }
          end
        end

        define_method :process_params do |params|
          [params, []]
        end
      end
    end

    context 'when block given' do
      it 'yields with processed collection' do
        expect do |b|
          fetcher.call(&b)
        end.to yield_with_args(be_success.and have_attributes(get: processed_collection))
      end
    end

    context 'when no block given' do
      subject { fetcher.call }

      it 'returns processed collection' do
        is_expected.to be_success
        is_expected.to have_attributes(get: processed_collection)
      end
    end
  end

  context 'filter, sorting and inheritance', database: true do
    require 'database_helper'

    let(:page_fetcher) do
      Class.new(Might::Fetcher) do
        filter :name

        self.resource_class = Page
      end
    end

    let(:another_page_fetcher) do
      Class.new(page_fetcher) do
        filter :slug
        sort :name
      end
    end

    it '' do
      params = {
        filter: {
          'name_not_eq' => 'Page #1',
          'slug_not_eq' => ''
        },
        sort: '-name',
        page: {
          limit: 1,
          offset: 1
        }
      }
      result = another_page_fetcher.new(params).call
      expect(result).to be_success

      pages = result.get.map(&:name)

      expect(pages).to eq(['Page #0'])
    end
  end
end
