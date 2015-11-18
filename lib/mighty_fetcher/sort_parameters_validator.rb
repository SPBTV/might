require 'mighty_fetcher/validation_error'

module MightyFetcher
  # Validates sortings and raises error if one of them is invalid
  #
  class SortParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<{:sort => MightyFetcher::FilterParameter}, Array>]
    # @return [<{:sort => MightyFetcher::FilterParameter}, Array>]
    #
    def call(env)
      params, errors = env

      not_allowed_parameters = Array(params[:sort]).select(&:invalid?)
      messages = not_allowed_parameters.flat_map(&:errors)

      app.call([params, errors.concat(messages)])
    end

    private

    attr_reader :app
  end
end
