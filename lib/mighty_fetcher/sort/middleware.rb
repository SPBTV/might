require 'mighty_fetcher/validation_error'
require_relative 'ransackable/parameters_converter'
require_relative 'ransackable/sort'
require_relative 'parameters_validator'
require_relative 'parameters_extractor'
require 'middleware'

module MightyFetcher
  module Sort
    # Sort scope using ransack gem
    #
    class Middleware
      # @param app [#call]
      # @param parameters_definition [Set<MightyFetcher::Sort:ParametersDefinition>] parameters to sort by
      #
      def initialize(app, parameters_definition)
        @app = app
        @parameters_definition = parameters_definition
      end

      attr_reader :app, :parameters_definition

      # @param [Array(ActiveRecord::Relation, Hash)] env
      # First argument is a ActiveRecord relation which must be sorted
      # Second argument is a request parameters provided by user
      #
      def call(env)
        scope, params = env
        sorted_scope, _ = ::Middleware::Builder.new do |b|
          b.use ParametersExtractor, parameters_definition
          b.use ParametersValidator
          b.use Ransackable::ParametersConverter
          b.use Ransackable::Sort
        end.call([scope, params[:sort]])

        app.call([sorted_scope, params])
      end
    end
  end
end
