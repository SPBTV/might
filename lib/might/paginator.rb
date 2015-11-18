# require 'active_support/core_ext/hash/keys'

module Might
  # Paginates ActiveRecord scopes
  # @example
  #
  #   Paginator.new(limit: 10, offset: 100).paginate(Movie.all)
  #
  # As a side effect of pagination it defines the following methods on collection:
  #   collection#limit
  #   collection#offset
  #   collection#count
  #   collection#total_count
  #
  class Paginator
    InvalidLimitOrOffset = Class.new(StandardError)

    attr_reader :limit, :offset

    # @param [{Symbol => Integer}] params
    # @option params [Integer] :limit
    # @option params [Integer] :offset
    #
    def initialize(options = {})
      @limit = Integer(options.fetch(:limit))
      @offset = Integer(options.fetch(:offset))

      fail InvalidLimitOrOffset if @limit < 0 || @offset < 0
    end

    # Paginate given collection
    # @param [ActiveRecord::CollectionProxy, ActiveRecord::Base] collection
    # @return [ActiveRecord::CollectionProxy]
    #
    def paginate(collection)
      paginated_collection = collection.offset(offset).limit(limit)

      pagination_hash = pagination(collection, paginated_collection)

      paginated_collection.define_singleton_method(:pagination) do
        pagination_hash
      end

      paginated_collection
    end

    private

    def pagination(collection, paginated_collection)
      {
        limit: limit,
        offset: offset,
        count: paginated_collection.count(:all),
        total: collection.count(:all),
      }
    end
  end
end
