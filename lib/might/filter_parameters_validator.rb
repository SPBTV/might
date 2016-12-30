# frozen_string_literal: true
module Might
  # Validates filters and raises error if one of them is invalid
  #
  class FilterParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<{:filter => <Might::FilterParameter>, Array>}]
    # @return [<{:filter => <Might::FilterParameter>, Array>}]
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
