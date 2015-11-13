require_relative 'filter_parameters_extractor'
require_relative 'filter_parameters_validator'
require_relative 'ransackable_filter'
require_relative 'ransackable_filter_parameters_adapter'
require 'middleware'
#
module MightyFetcher
  # Filter scope using ransack gem
  #
  class FilterMiddleware
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
        b.use FilterParametersExtractor, parameters_definition
        b.use FilterParametersValidator
        b.use RansackableFilterParametersAdapter
        b.use RansackableFilter
      end.call([scope, params])

      app.call([filtered_scope, params])
    end

    private

    attr_reader :parameters_definition, :app
  end
end
