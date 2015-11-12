require_relative 'parameters_extractor'
require_relative 'parameters_validator'
require_relative 'ransackable/filter'
require_relative 'ransackable/parameters_converter'
require 'middleware'
#
module MightyFetcher
  #
  module Filter
    # Filter scope using ransack gem
    #
    class Middleware
      # @param app [#call, Proc]
      # @param parameters_definition [Set<String>] is a names of allowed parameters to filter on
      #
      def initialize(app, parameters_definition)
        @app = app
        @parameters_definition = parameters_definition
      end

      def call(env)
        scope, params = env

        filtered_scope, _ = ::Middleware::Builder.new do |b|
          b.use ParametersExtractor, parameters_definition
          b.use ParametersValidator
          b.use Ransackable::ParametersConverter
          b.use Ransackable::Filter
        end.call([scope, params[:filter]])

        app.call([filtered_scope, params])
      end

      private

      attr_reader :parameters_definition, :app
    end
  end
end
