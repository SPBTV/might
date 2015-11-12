require_relative 'ransackable_filter'
require_relative 'extractor'
#
module MightyFetcher
  #
  module Filter
    # Filter scope using ransack gem
    #
    class Middleware
      # @param app [#call, Proc]
      # @param parameters_definition [Set<String>] is a names of allowed parameters to filter on
      #
      def initialize(app, parameters_definition)
        @app = app
        @parameters_definition = parameters_definition
      end

      attr_reader :parameters_definition, :app

      def call(env)
        scope, params = env
        filter_provided_by_user = extract_filters(params)

        validate_filters!(filter_provided_by_user)

        filtered_scope = RansackableFilter.new(filter_provided_by_user).filter(scope)

        app.call([filtered_scope, params])
      end

      private

      def extract_filters(params)
        Extractor.new(params, parameters_definition).call
      end

      # @param [Array(<Parameter>)] filters given by user
      # @return [void]
      # @raise [ResourceFetcher::FilterValidationFailed] Is user provided invalid value for the given filter
      def validate_filters!(filters)
        invalid_filters = filters.select(&:invalid?)

        if invalid_filters.any?
          fail MightyFetcher::FilterValidationFailed, invalid_filters.map(&:errors)
        end
      end
    end
  end
end
