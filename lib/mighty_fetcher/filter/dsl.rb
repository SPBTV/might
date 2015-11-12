require 'set'
require_relative 'parameter_definition'

module MightyFetcher
  module Filter
    # Expose to Fetcher DSL for defining and using filters
    # @example
    #   class MovieFetcher
    #     extend Filter::DSL
    #
    #     filter :id, validates: { presence: true }
    #     filter :name
    #     filter :start_at, validates: { presence: true }
    #   end
    #
    # If your property name doesn't match the name in the query string, use the :as option:
    #
    #   filter :kind, as: :type
    #
    # So the Movie#kind property would be exposed to API as :type
    #
    module DSL
      # Register collection filter by its name
      # @see +MightyFetcher::Filter+ for details
      #
      # @overload filter(filter_name, options)
      #   @param [Symbol] filter_name
      #   @param [Hash] options
      #   @return [void]
      # @example
      #   filter :genre_name, on: :resource
      #
      # @overload filter(filter_name: predicates, **options)
      #   @param [Symbol] filter_name
      #   @param [<Symbol>] predicates
      #   @param [Hash] other options options
      #   @return [void]
      # @example
      #   filter genre_name: [:eq, :in], on: :resource
      #
      def filter(*args)
        options = args.extract_options!
        if args.empty?
          filter_name = options.keys.first
          predicates = options.values.first
          options = options.except(filter_name).merge(predicates: predicates)
        else
          filter_name = args.first
        end

        definition = ParameterDefinition.new(filter_name, options)
        filter_parameters_definition.add(definition)
      end

      def filter_parameters_definition
        @filter_parameters_definition ||= Set.new
      end
    end
  end
end
