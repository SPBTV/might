# require_relative 'validator'
require 'might/paginator'

module Might
  # Pagination middleware
  #
  class PaginationMiddleware
    # @param app [#call, Proc]
    # @param max_per_page [Integer]
    # @param per_page [Integer]
    #
    def initialize(app, max_per_page: false, per_page: 50)
      @app = app
      @max_per_page = max_per_page
      @per_page = per_page
    end

    # @param [Array(ActiveRecord::Relation, Hash)] env
    # First argument is a ActiveRecord relation which must be paginated
    # Second argument is a request parameters provided by user
    #
    def call(env)
      scope, params = env
      # validate_parameters!(params)
      paginated_scope = Paginator.new(pagination_options(params)).paginate(scope)
      app.call([paginated_scope, params])
    end

    private

    attr_reader :app

    # def validate_parameters!(params)
    #   validator = Validator.new(params[:page])
    #   fail(PaginationValidationFailed, validator.errors) unless validator.valid?
    # end

    # @param [Hash] params
    # @option params [Hash] (nil) :limit
    # @option params [Hash] (nil) :offset
    #
    def pagination_options(params)
      options = default_pagination_options.merge(Hash(params[:page]))
      max_per_page = @max_per_page

      if max_per_page && options[:limit] > max_per_page
        options.merge(limit: max_per_page)
      else
        options
      end
    end

    def default_pagination_options
      {
        limit: @per_page,
        offset: 0
      }.with_indifferent_access
    end
  end
end