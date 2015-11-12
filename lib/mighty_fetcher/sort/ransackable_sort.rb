module MightyFetcher
  module Sort
    # Apply all sortings to collection.
    #
    class RansackableSort
      # @return [Array<Symbol>]
      #
      attr_reader :sorting_order

      # @param [Array<Sorting>] sorting_order
      #
      def initialize(sorting_order = nil)
        @sorting_order = Array(sorting_order).map do |parameter|
          "#{parameter.name} #{parameter.direction}"
        end
      end

      # Sort given collection
      # @param [ActiveRecord::CollectionProxy, ActiveRecord::Base] collection
      # @return [ActiveRecord::CollectionProxy]
      #
      def sort(collection)
        ransackable_query = collection.ransack
        ransackable_query.sorts = sorting_order
        ransackable_query.result
      end
    end
  end
end
