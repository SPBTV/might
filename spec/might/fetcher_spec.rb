# frozen_string_literal: true
RSpec.describe Might::Fetcher do
  describe '#call' do
    let(:params) { double('params') }
    let(:fetcher) { fetcher_class.new(params, &decorate_resource_class) }
    let(:decorate_resource_class) { nil }
    let(:resource_class) { double('resource_class') }

    def fetcher_class
      s = self

      Class.new(described_class) do
        self.resource_class = s.resource_class
        define_method :fetch_middleware do
          ::Middleware::Builder.new do |b|
            b.use ->(collection_and_params) { [[:processed, collection_and_params.first], collection_and_params.last] }
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
        end.to yield_with_args(be_success.and(have_attributes(get: [:processed, resource_class])))
      end
    end

    context 'when no block given' do
      subject { fetcher.call }

      it 'returns processed collection' do
        is_expected.to be_success.and(have_attributes(get: [:processed, resource_class]))
      end
    end

    context 'when initial resource class is decorated' do
      subject { fetcher.call }
      let(:decorate_resource_class) { ->(resource_class) { [:decorated, resource_class] } }

      it 'returns processed collection' do
        is_expected.to be_success.and(have_attributes(get: [:processed, [:decorated, resource_class]]))
      end
    end
  end

  context 'filter, sorting and inheritance', database: true do
    require 'database_helper'

    let!(:other_fetcher) do
      Class.new(Might::Fetcher) do
        filter :some_field, validates: { presence: true }

        self.resource_class = Page
      end
    end

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
          'slug_not_eq' => '',
        },
        sort: '-name',
        page: {
          limit: 1,
          offset: 1,
        },
      }
      result = another_page_fetcher.new(params).call
      expect(result).to be_success

      pages = result.get.map(&:name)

      expect(pages).to eq(['Page #0'])
    end
  end
end
