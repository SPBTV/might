module Might
  # Validates sortings and raises error if one of them is invalid
  #
  class SortParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<{:sort => Might::FilterParameter}, Array>]
    # @return [<{:sort => Might::FilterParameter}, Array>]
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
