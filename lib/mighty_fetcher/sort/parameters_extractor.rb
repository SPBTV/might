require_relative 'undefined_parameter'
require_relative 'parameter'

module MightyFetcher
  module Sort
    # User provided sorting syntax:
    #   * `name` - sort by name
    #   * `-name` - sort by name in reversed order
    #   * `-name,created_at` - sort by name in reversed order, and then sort by created_at
    #
    # This middleware parses sorting string and builds Parameter array
    # @see MightyFetcher::Sort::Parameter
    #
    # If user passes not defined sort order, it yields to `UndefinedParameter`, so you may
    # validate it.
    #
    class ParametersExtractor
      # @param app [#call]
      # @param parameters_definition [Set<MightyFetcher::Sort::ParameterDefinition>]
      def initialize(app, parameters_definition)
        @app = app
        @parameters_definition = parameters_definition
      end

      # @param env [<ActiveRecord::Relation, String>]
      #   * first element is a scope to be sorted
      #   * second is a String with user provided sortings
      # @return [<ActiveRecord::Relation, <MightyFetcher::Sort::Parameter>]
      #
      def call(env)
        scope, params = env

        parameters = sort_order(params).map do |(attribute, direction)|
          extract_parameter(attribute, direction)
        end

        app.call([scope, parameters])
      end

      private

      attr_reader :parameters_definition, :app

      def extract_parameter(name, direction)
        definition = parameters_definition.detect { |d| d.as == name } || UndefinedParameter.new(name)
        Parameter.new(direction, definition)
      end

      def sort_order(params)
        params.split(',').map do |attribute|
          sorting_for(attribute)
        end
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

