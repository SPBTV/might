require 'active_support/core_ext/string/strip'
require 'mighty_fetcher/base'

RSpec.describe MightyFetcher::Base do
  describe '#call' do
    def fetcher_class(collection)
      klass = double('resource_class', all: collection)

      Class.new(described_class) do
        self.resource_class = klass
      end
    end

    let(:params) { double('params') }
    let(:collection) { double('collection') }
    let(:processed_collection) { double('processed_collection') }
    let(:fetcher) { fetcher_class(collection).new(params) }

    before do
      expect(fetcher).to receive(:middleware_stack) do
        ::Middleware::Builder.new do |b|
          b.use ->(_) { processed_collection }
        end
      end
    end

    context 'when block given' do
      it 'yields with processed collection' do
        expect do |b|
          fetcher.call(&b)
        end.to yield_with_args(processed_collection)
      end
    end

    context 'when no block given' do
      subject { fetcher.call }

      it 'returns processed collection' do
        is_expected.to eq(processed_collection)
      end
    end
  end
end
