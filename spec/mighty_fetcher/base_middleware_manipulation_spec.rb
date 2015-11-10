require 'mighty_fetcher/base'
require_relative 'inserted middleware_examples'

RSpec.describe MightyFetcher::Base, 'middleware stack builder' do
  include_examples 'inserted middleware', :after
  include_examples 'inserted middleware', :before

  context 'middleware may be configured' do
    def fetcher_class
      klass = double('resource_class', all: [])
      # Define imaginary DSL with memoizable options
      dsl = Module.new do
        def option(name)
          options.push(name)
        end

        def options
          @options ||= []
        end
      end

      Class.new(described_class) do
        extend dsl
        self.resource_class = klass

        self.middleware = ::Middleware::Builder.new do |b|
          b.use ->(_env, options) { options }, self.options
        end

        option :foo

        middleware.use ->(options) { options }

        option :bar
      end
    end

    subject { fetcher_class.middleware.call }

    it 'contains option added before changing middleware' do
      is_expected.to include(:foo)
    end

    it 'contains option added after changing middleware' do
      is_expected.to include(:bar)
    end

    it 'it does not affect base class middleware' do
      base_middlewares = described_class.middleware.inspect
      subclass_middlewares = fetcher_class.middleware.inspect
      expect(base_middlewares).not_to eq(subclass_middlewares)
    end
  end
end
