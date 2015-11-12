require 'set'
require_relative 'parameter_definition'

module MightyFetcher
  module Sort
    # Expose to Sort DSL for defining and using sortings
    #
    # @example
    #   class MovieFetcher
    #     extend Sort::DSL
    #
    #     sort :id
    #     sort :name
    #   end
    #
    # If your property name doesn't match the name in the query string, use the :as option:
    #
    #   sort :position, as: :relevance
    #
    # So client should pass +?sort=relevance+ in order to sort by position
    #
    # It's also possible to reverse meaning of the order direction. For example it's not
    # make sense to order by position from lower value to higher.
    # The meaning default for that sorting is reversed order by default, so more relevant elenents
    # would be the first.
    #
    #   sort :position, as: :relevance, reverse_direction: true
    #
    module DSL
      # Register collection sorting by its name
      # @param [Symbol] name of the field
      # @return [void]
      # @see +RansackableSort+ for details
      #
      def sort(name, options = {})
        definition = ParameterDefinition.new(name, options)
        sort_parameters_definition.add(definition)
      end

      def sort_parameters_definition
        @sort_parameters_definition ||= Set.new
      end
    end
  end
end
