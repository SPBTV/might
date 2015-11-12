require_relative 'undefined_parameter'
require_relative 'parameter'

module MightyFetcher
  #
  module Sort
    # Is a thin layer between API sorting syntax and
    # syntax supported by the Ransack.
    #
    class Extractor
      # @param [Hash] params
      # @option params [Hash] :filter
      # @param [Set<ParameterDefinition>] definitions
      #
      def initialize(params, definitions)
        @params = params
        @definitions = definitions
      end

      # @return [Array<Parameter>]
      #
      def call
        sort_order.map do |(attribute, direction)|
          extract_parameter(attribute, direction)
        end
      end

      # @return [Array<Symbol>] of sorting fields
      #
      def attributes
        sort_order.map(&:first)
      end

      private

      attr_reader :params, :definitions

      # @param [String] name
      # @param ['asc', 'desc'] direction
      #
      def extract_parameter(name, direction)
        definition = definitions.detect { |d| d.as == name } || UndefinedParameter.new(name)
        Parameter.new(direction, definition)
      end

      def sort_order
        @sort_order ||=
          sort_param.split(',').map do |attribute|
            sorting_for(attribute)
          end
      end

      def sort_param
        @sort_param ||= String(params[:sort])
      end

      def sorting_for(field)
        if field.start_with?('-')
          [field.delete('-'), 'desc']
        else
          [field, 'asc']
        end
      end
    end
  end
end
