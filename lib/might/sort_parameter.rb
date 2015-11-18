require 'active_support/core_ext/module/delegation'

module Might
  # User provided filtering on particular parameter
  #
  class SortParameter
    DIRECTIONS = %w(asc desc).freeze
    REVERSED_DIRECTIONS = {
      'asc' => 'desc',
      'desc' => 'asc'
    }.freeze

    attr_reader :direction

    # @return [ParameterDefinition]
    #
    attr_reader :definition

    # @param ['asc', desc'] direction
    # @param [SortParameterDefinition]
    #
    def initialize(direction, definition)
      @direction = direction.to_s
      fail ArgumentError unless DIRECTIONS.include?(@direction)
      @definition = definition
      @validator = definition.validator
    end

    attr_reader :validator
    delegate :name, to: :definition
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
