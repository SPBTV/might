require 'active_support/core_ext/module/delegation'

module MightyFetcher
  module Sort
    # User provided filtering on particular parameter
    #
    class Parameter
      DIRECTIONS = %w(asc desc).freeze
      REVERSED_DIRECTIONS = {
        'asc' => 'desc',
        'desc' => 'asc',
      }.freeze

      attr_reader :direction

      # @return [ParameterDefinition]
      #
      attr_reader :definition

      # @param ['asc', desc'] direction
      # @param [ParameterDefinition]
      #
      def initialize(direction, definition)
        @direction = direction.to_s
        fail ArgumentError unless DIRECTIONS.include?(@direction)
        @definition = definition
      end

      delegate :name, to: :definition
      delegate :validator, to: :definition
      delegate :valid?, to: :validator
      delegate :invalid?, to: :validator

      def errors
        validator.errors.full_messages
      end

      def ==(other)
        is_a?(other.class) &&
          direction == other.direction &&
          definition == other.definition
      end

      # @return ['asc', desc']
      #
      def direction
        if definition.reverse_direction?
          REVERSED_DIRECTIONS[@direction]
        else
          @direction
        end
      end
    end
  end
end
