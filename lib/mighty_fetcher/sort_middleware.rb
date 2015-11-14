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
    #
    def initialize(app)
      @app = app
    end

    attr_reader :app

    # @param [Array(ActiveRecord::Relation, Hash)] env
    # First argument is a ActiveRecord relation which must be sorted
    # Second argument is a request parameters provided by user
    #
    def call(env)
      scope, _ = ::Middleware::Builder.new do |b|
        b.use RansackableSortParametersAdapter
        b.use RansackableSort
      end.call(env)

      app.call([scope, env[1]])
    end
  end
end
