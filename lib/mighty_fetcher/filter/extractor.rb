require_relative 'predicates'
require_relative 'undefined_parameter'
require_relative 'parameter'

module MightyFetcher
  module Filter
    # Is a thin layer between API filtering syntax and
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

      # Filters ready for Ransacker
      # @return [Array<Parameter>]
      #
      def call
        provided_parameters = params.each_with_object([]) do |(name, value), parameters|
          type_casted_value = type_cast_value(name, value)
          parameters << extract_parameter(name, type_casted_value)
        end

        not_provided_parameters = definitions - provided_parameters.map(&:definition)

        undefined_parameters = not_provided_parameters.map do |definition|
          Parameter.new(nil, nil, definition)
        end

        # Keep even undefined parameters to validate required ones
        provided_parameters + undefined_parameters
      end

      private

      attr_reader :definitions

      def name_and_predicate(name_with_predicate)
        predicate = Predicates::ALL.detect { |p| name_with_predicate.end_with?("_#{p}") }
        [
          name_with_predicate.chomp("_#{predicate}"),
          predicate,
        ]
      end

      # @param [String] name
      # @param [String, Array<String>] value
      #
      def extract_parameter(name, value)
        name, predicate = name_and_predicate(name)
        definition = definitions.detect { |d| d.as == name } || UndefinedParameter.new(name)
        Parameter.new(value, predicate, definition)
      end

      def type_cast_value(name, value)
        if name.end_with?(*Predicates::ON_ARRAY)
          value.split(',')
        else
          value
        end
      end

      def params
        @filter_params ||= Hash(@params[:filter])
      end
    end
  end
end
