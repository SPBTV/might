require 'mighty_fetcher/validation_error'

module MightyFetcher
  # Validates filters and raises error if one of them is invalid
  #
  class FilterParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<{:filter => <MightyFetcher::FilterParameter>, Array>}]
    # @return [<{:filter => <MightyFetcher::FilterParameter>, Array>}]
    #
    def call(env)
      params, errors = env

      invalid_filters = Array(params[:filter]).select(&:invalid?)
      messages = invalid_filters.flat_map(&:errors)

      app.call([params, errors.concat(messages)])
    end

    private

    attr_reader :app
  end
end
