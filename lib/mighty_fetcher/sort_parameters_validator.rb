require 'mighty_fetcher/validation_error'

module MightyFetcher
  # Validates sortings and raises error if one of them is invalid
  #
  class SortParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<Set<MightyFetcher::RansackableSort::SortParameter, []>]
    # @return [<Set<MightyFetcher::RansackableSort::SortParameter, []>]
    # @raise MightyFetcher::SortOrderValidationFailed
    #
    def call(env)
      params, errors = env

      not_allowed_parameters = Array(params[:sort]).select(&:invalid?)

      if not_allowed_parameters.any?
        fail MightyFetcher::SortOrderValidationFailed, not_allowed_parameters.map(&:errors)
      end

      app.call([params, errors])
    end

    private

    attr_reader :app
  end
end
