require 'mighty_fetcher/validation_error'

module MightyFetcher
  # Validates sortings and raises error if one of them is invalid
  #
  class SortParametersValidator
    # @param app [#call]
    def initialize(app)
      @app = app
    end

    # @param env [<ActiveRecord::Relation, Set<MightyFetcher::RansackableSort::SortParameter>]
    # @return [<ActiveRecord::Relation, Set<MightyFetcher::RansackableSort::SortParameter>]
    # @raise MightyFetcher::SortOrderValidationFailed
    #
    def call(env)
      scope, parameters = env

      not_allowed_parameters = parameters.select(&:invalid?)

      if not_allowed_parameters.any?
        fail MightyFetcher::SortOrderValidationFailed, not_allowed_parameters.map(&:errors)
      end

      app.call([scope, parameters])
    end

    private

    attr_reader :app
  end
end
