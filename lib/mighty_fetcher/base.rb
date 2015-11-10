require 'uber/inheritable_attr'
require 'middleware'

#
module MightyFetcher
  # Configure your own fetcher
  #
  #   PagesFetcher < MightyFetcher::Base
  #     self.resource_class = Page
  #   end
  #
  class Base
    extend Uber::InheritableAttr

    inheritable_attr :resource_class

    # @return [Hash]
    attr_reader :params

    # @param params [Hash]
    def initialize(params)
      @params = params
    end

    # @return [ActiveRecord::Relation] filtered and sorted collection
    # @yieldparam collection [ActiveRecord::Relation] if a block given
    #
    # @example
    #   PagesFetcher.new(params).call #=> ActiveRecord::Relation
    #
    # @example block syntax
    #   PagesFetcher.new(params) do |collection|
    #     ...
    #   end
    #
    def call
      processed_collection, = middleware_stack.call([collection, params])

      if block_given?
        yield processed_collection
      else
        processed_collection
      end
    end

    private

    # @return [ActiveRecord::Relation]
    def collection
      self.class.resource_class.all
    end

    def middleware_stack
      ::Middleware::Builder.new do |b|
        b.use ->(env) { env }
      end
    end

    class << self
      # @param params [Hash] user provided input
      # @yieldparam collection [ActiveRecord::Relation]
      def run(params, &block)
        new(params).call(&block)
      end
    end
  end
end
