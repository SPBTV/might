require 'mighty_fetcher/validation_error'
require_relative 'extractor'
require_relative 'ransackable_sort'

module MightyFetcher
  module Sort
    # Sort scope using ransack gem
    #
    class Middleware
      # @param [Middleware::Abstract] app
      # @param [Set<String>] parameters_definition is a names of allowed parameters to sort by
      #
      def initialize(app, parameters_definition)
        @app = app
        @parameters_definition = parameters_definition
      end

      attr_reader :app, :parameters_definition

      # @param [Array(ActiveRecord::Relation, Hash)] env
      # First argument is a ActiveRecord relation which must be sorted
      # Second argument is a request parameters provided by user
      #
      def call(env)
        scope, params = env
        sort_order_provided_by_user = extract_sort_order(params)

        validate_sorting_attributes_passed!(sort_order_provided_by_user)

        sorted_scope = RansackableSort.new(sort_order_provided_by_user).sort(scope)
        app.call([sorted_scope, params])
      end

      private

      def extract_sort_order(params)
        Extractor.new(params, parameters_definition).call
      end

      # @param [Array(<Symbol>)] filters given by user
      # @return [void]
      # @raise [ResourceFetcher::FilterNotAllowed] if user provide not white-listed filter
      #
      def validate_sorting_attributes_passed!(parameters)
        not_allowed_parameters = parameters.select(&:invalid?)

        if not_allowed_parameters.any?
          fail MightyFetcher::SortOrderValidationFailed, not_allowed_parameters.map(&:errors)
        end
      end
    end
  end
end
