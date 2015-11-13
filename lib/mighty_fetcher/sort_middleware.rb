require 'mighty_fetcher/validation_error'
require 'mighty_fetcher/ransackable_sort_parameters_adapter'
require 'mighty_fetcher/ransackable_sort'
require 'mighty_fetcher/sort_parameters_validator'
require 'mighty_fetcher/sort_parameters_extractor'
require 'middleware'

module MightyFetcher
  # Sort scope using ransack gem
  #
  class SortMiddleware
    # @param app [#call]
    # @param parameters_definition [Set<MightyFetcher::RansackableSort:ParametersDefinition>] parameters to sort by
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
        b.use SortParametersExtractor, parameters_definition
        b.use SortParametersValidator
        b.use RansackableSortParametersAdapter
        b.use RansackableSort
      end.call([scope, params[:sort]])

      app.call([sorted_scope, params])
    end
  end
end
