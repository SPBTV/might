require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'

module MightyFetcher
  # User provided filtering on particular parameter
  #
  class FilterParameter
    # @return [String, nil]
    #
    attr_reader :predicate

    # @return [ParameterDefinition, nil]
    #
    attr_reader :definition

    def initialize(value, predicate, definition)
      @value = value
      @predicate = predicate.to_s
      @definition = definition
    end

    delegate :name, to: :definition
    delegate :on, to: :definition

    # Check if this parameter provided by user.
    # If the parameter defined by not given by user this returns false.
    # @return [Boolean]
    def provided?
      value.present? && predicate.present?
    end

    def ==(other)
      is_a?(other.class) &&
        value == other.value &&
        predicate == other.predicate &&
        definition == other.definition
    end

    # @return [String, Array<String>]
    # TODO: memoize
    def value
      if @value.is_a?(Array)
        @value.map { |v| definition.coerce(v) }
      else
        definition.coerce(@value)
      end
    end

    def valid?
      validators.all?(&:valid?)
    end

    def invalid?
      validators.any?(&:invalid?)
    end

    def errors
      validators.map(&:errors).flat_map(&:full_messages).compact.uniq
    end

    private

    def validators
      values_for_validation = @value.is_a?(Array) ? @value : [@value]
      @validators ||= values_for_validation.map { |v| definition.validator.new(v) }
    end
  end
end
