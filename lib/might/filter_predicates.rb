# frozen_string_literal: true
module Might
  # Contains contains with all supported predicates
  # You can register your own predicates. Predicates should perform on array or on singular value:
  #
  #   Might::FilterPredicates.register('includes', on: :array)
  #   Might::FilterPredicates.register('is_upper_case', on: :value)
  #
  module FilterPredicates
    NOT_EQ = 'not_eq'
    EQ = 'eq'
    DOES_NOT_MATCH = 'does_not_match'
    MATCHES = 'matches'
    GT = 'gt'
    LT = 'lt'
    GTEQ = 'gteq'
    LTEQ = 'lteq'
    NOT_CONT = 'not_cont'
    CONT = 'cont'
    NOT_START = 'not_start'
    START = 'start'
    DOES_NOT_END = 'not_end'
    ENDS = 'end'
    NOT_TRUE = 'not_true'
    TRUE = 'true'
    NOT_FALSE = 'not_false'
    FALSE = 'false'
    BLANK = 'blank'
    PRESENT = 'present'
    NOT_NULL = 'not_null'
    NULL = 'null'
    NOT_IN = 'not_in'
    IN = 'in'
    NOT_CONT_ANY = 'not_cont_any'
    CONT_ANY = 'cont_any'

    @predicates_on_value = Set.new([
      NOT_EQ, EQ,
      DOES_NOT_MATCH, MATCHES,
      GT, LT,
      GTEQ, LTEQ,
      NOT_CONT, CONT,
      NOT_START, START,
      DOES_NOT_END, ENDS,
      NOT_TRUE, TRUE,
      NOT_FALSE, FALSE,
      BLANK, PRESENT,
      NOT_NULL, NULL
    ])
    @predicates_on_array = Set.new([
      NOT_IN, IN,
      NOT_CONT_ANY, CONT_ANY
    ])

    # Registers predicate on singular value or on array
    # @param predicate [String, Symbol]
    # @param on [:array, :value]
    # @return [Might::FilterPredicates]
    #
    def register(predicate, on:)
      case on
      when :value
        @predicates_on_value.add(predicate.to_s)
      when :array
        @predicates_on_array.add(predicate.to_s)
      else
        fail ArgumentError, 'on must be :array, or :value'
      end
      self
    end
    module_function :register

    # Returns predicates for array
    # @return [Set<String>]
    #
    def array
      @predicates_on_array.dup
    end
    module_function :array

    # Returns predicates for values
    # @return [Set<String>]
    #
    def value
      @predicates_on_value.dup
    end
    module_function :value

    # Returns all predicates
    # @return [Set<String>]
    #
    def all
      @predicates_on_value + @predicates_on_array
    end
    module_function :all
  end
end
