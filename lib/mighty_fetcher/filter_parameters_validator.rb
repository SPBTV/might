require 'mighty_fetcher/validation_error'

module MightyFetcher
  # Validates filters and raises error if one of them is invalid
  #
  class FilterParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<ActiveRecord::Relation, Set<MightyFetcher::FilterParameter>]
    # @return [<ActiveRecord::Relation, Set<MightyFetcher::FilterParameter>]
    # @raise MightyFetcher::FilterValidationFailed
    #
    def call(env)
      scope, filters = env
      invalid_filters = filters.select(&:invalid?)

      if invalid_filters.any?
        fail MightyFetcher::FilterValidationFailed, invalid_filters.map(&:errors)
      end
      app.call([scope, filters])
    end

    private

    attr_reader :app
  end
end
