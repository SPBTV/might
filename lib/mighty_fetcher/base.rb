require 'active_support/core_ext/module/delegation'
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
    inheritable_attr :middleware

    self.middleware = ::Middleware::Builder.new

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
      processed_collection, = self.class.middleware.call([collection, params])

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

    class << self
      # @param params [Hash] user provided input
      # @yieldparam collection [ActiveRecord::Relation]
      def run(params, &block)
        new(params).call(&block)
      end

      # Add middleware to the end of middleware chane
      # When only one argument given, it is treated as scope. So the lambda must
      # return modified scope:
      #
      #   class MovieFetcher
      #     after do |scope|
      #       # do something with scope
      #       scope.map(&:resource)
      #     end
      #   end
      #
      # When two arguments given, they are treated as scope and params. So the lambda must
      # return tuple:
      #
      #   class MovieFetcher
      #     after do |scope, params|
      #       # do something with scope and params
      #       [scope.map(&:resource), params]
      #     end
      #   end
      #
      def after(&block)
        alter_middleware :use, &block
      end

      # Add middleware to the beginning of middleware chane
      # When only one argument given, it is treated as scope. So the lambda must
      # return modified scope:
      #
      #   class MovieFetcher
      #     before do |scope|
      #       # do something with scope
      #       scope.map(&:resource)
      #     end
      #   end
      #
      # When two arguments given, they are treated as scope and params. So the lambda must
      # return tuple:
      #
      #   class MovieFetcher
      #     before do |scope, params|
      #       # do something with scope and params
      #       [scope.map(&:resource), params]
      #     end
      #   end
      #
      def before(middleware_or_index = 0, &block)
        alter_middleware :insert_before, middleware_or_index, &block
      end

      private

      def alter_middleware(method_name, *args, &block)
        fail ArgumentError unless block_given?
        middleware.send method_name, *args, lambda { |env|
          scope, params = env
          case block.arity
          when 1
            [block.call(scope), params]
          when 2
            block.call(scope, params).tap do |r|
              if !r.is_a?(Array) || r.size != 2
                fail 'After block must return tuple of scope and params'
              end
            end
          else
            fail "Wrong number of arguments (#{block.arity} for 0..2)"
          end
        }
      end
    end
  end
end
