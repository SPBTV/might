require 'mighty_fetcher/base'

RSpec.describe MightyFetcher::Base do
  describe '#call' do
    let(:params) { double('params') }
    let(:collection) { double('collection') }
    let(:processed_collection) { double('processed_collection') }
    let(:fetcher) { fetcher_class(collection, processed_collection).new(params) }

    def fetcher_class(collection, processed_collection)
      klass = double('resource_class', all: collection)

      Class.new(described_class) do
        self.resource_class = klass
        self.middleware = ::Middleware::Builder.new do |b|
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
