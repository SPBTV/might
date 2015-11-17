require 'mighty_fetcher/validation_error'

module MightyFetcher
  # Validates filters and raises error if one of them is invalid
  #
  class FilterParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<{:filter => Set<MightyFetcher::FilterParameterm, []>}]
    # @return [<{:filter => Set<MightyFetcher::FilterParameter, []>}]
    # @raise MightyFetcher::FilterValidationFailed
    #
    def call(env)
      params, errors = env
      invalid_filters = Array(params[:filter]).select(&:invalid?)

      if invalid_filters.any?
        fail MightyFetcher::FilterValidationFailed, invalid_filters.map(&:errors)
      end
      app.call([params, errors])
    end

    private

    attr_reader :app
  end
end
