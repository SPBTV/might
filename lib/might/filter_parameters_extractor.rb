require_relative 'filter_predicates'
require_relative 'filter_undefined_parameter'
require_relative 'filter_parameter'

module Might
  # User provided filters syntax:
  #   * `{ 'name_eq' => 'Martin' }` - name is equal to Martin
  #   * `{ 'name_in' => 'Martin,Bob' }` - name is either Martin or Bob
  #
  # This middleware parses filters hash and builds Parameter array
  # @see Might::FilterParameter
  #
  # If user passes not defined filter, it yields to `UndefinedParameter`, so you may
  # validate it.
  #
  class FilterParametersExtractor
    # @param app [#call]
    # @param parameters_definition [Set<Might::FilterParameterDefinition>]
    def initialize(app, parameters_definition)
      @app = app
      @parameters_definition = parameters_definition
    end

    # @param env [<{:filter => Hash}, []>]
    #   * first element is a scope to be filtered
    #   * second is a hash with user provided filters
    # @return [<{:filter => <Might::FilterParameter>, []}]
    #
    def call(env)
      params, errors = env

      provided_parameters = Hash(params[:filter]).each_with_object([]) do |(name, value), parameters|
        type_casted_value = type_cast_value(name, value)
        parameters << extract_parameter(name, type_casted_value)
      end

      not_provided_parameters = parameters_definition - provided_parameters.map(&:definition)

      undefined_parameters = not_provided_parameters.map do |definition|
        FilterParameter.new(nil, nil, definition)
      end

      # Keep even undefined parameters to validate required ones
      filters = provided_parameters + undefined_parameters

      app.call([params.merge(filter: filters), errors])
    end

    private

    attr_reader :parameters_definition, :app

    def name_and_predicate(name_with_predicate)
      predicate = FilterPredicates::ALL.detect { |p| name_with_predicate.end_with?("_#{p}") }
      [
        name_with_predicate.chomp("_#{predicate}"),
        predicate
      ]
    end

    # @param [String] name
    # @param [String, Array<String>] value
    #
    def extract_parameter(name, value)
      name, predicate = name_and_predicate(name)
      definition = parameters_definition.detect { |d| d.as == name } || FilterUndefinedParameter.new(name)
      FilterParameter.new(value, predicate, definition)
    end

    def type_cast_value(name, value)
      if name.end_with?(*FilterPredicates::ON_ARRAY)
        value.split(',')
      else
        value
      end
    end
  end
end
