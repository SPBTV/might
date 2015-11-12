module MightyFetcher
  # Converts array of parameters to hash familiar to ransack gem
  #
  class RansackableFilterParametersConverter
    def initialize(app)
      @app = app
    end

    def call(env)
      scope, parameters = env

      ransackable_parameters = Array(parameters).reject { |f| f.predicate.nil? }
                                 .each_with_object({}) do |filter, ransackable_filters|
        ransackable_filters[canonical_name_for(filter)] = filter.value
      end

      app.call([scope, ransackable_parameters])
    end

    private

    attr_reader :app

    # @return [String, nil] filter with predicate. E.g. `first_name_eq`
    #   nil value means that
    #
    def canonical_name_for(filter)
      if filter.on.is_a?(Hash)
        name_for_polymorphic(filter)
      else
        [filter.on, filter.name, filter.predicate].compact.join('_')
      end
    end

    # Build query method for polymorphic association
    # @see https://github.com/activerecord-hackery/ransack/wiki/Polymorphic-searches
    # @see https://github.com/activerecord-hackery/ransack/commit/c156fa4a7ac6e1a8d730791c49bf4403aa0f3af7#diff-a26803e1ff6e56eb67b80c91d79a063eR34
    # @param [SortParameter] filter
    # @return [String]
    #
    # @example
    #
    #   definition = ParameterDefinition.new('genre_name', on: { resource: ['Movie', 'Channel'] })
    #   parameter = Parameter.new('Horror', 'eq', definition)
    #   name_for_polymorphic(parameter)
    #     #=> 'resource_of_Movie_type_genre_name_or_resource_of_Channel_type_genre_name_eq'
    #
    def name_for_polymorphic(filter)
      unless filter.on.size == 1
        fail ArgumentError, 'Polymorphic association must be defined as Hash with single value'
      end
      polymorphic_name = filter.on.keys.first

      name = Array(filter.on.values.first)
               .map { |polymorphic_type| "#{polymorphic_name}_of_#{polymorphic_type}_type_#{filter.name}" }
               .join('_or_')

      "#{name}_#{filter.predicate}"
    end
  end
end
