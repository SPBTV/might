module Might
  # Contains contains with all supported predicates
  # You can register your own predicates. Predicates should perform on array or on singular value:
  #
  #   Might::FilterPredicates.register('includes', on: :array)
  #   Might::FilterPredicates.register('is_upper_case', on: :value)
  #
  module FilterPredicates
    NOT_EQ = 'not_eq'.freeze
    EQ = 'eq'.freeze
    DOES_NOT_MATCH = 'does_not_match'.freeze
    MATCHES = 'matches'.freeze
    GT = 'gt'.freeze
    LT = 'lt'.freeze
    GTEQ = 'gteq'.freeze
    LTEQ = 'lteq'.freeze
    NOT_CONT = 'not_cont'.freeze
    CONT = 'cont'.freeze
    NOT_START = 'not_start'.freeze
    START = 'start'.freeze
    DOES_NOT_END = 'not_end'.freeze
    ENDS = 'end'.freeze
    NOT_TRUE = 'not_true'.freeze
    TRUE = 'true'.freeze
    NOT_FALSE = 'not_false'.freeze
    FALSE = 'false'.freeze
    BLANK = 'blank'.freeze
    PRESENT = 'present'.freeze
    NOT_NULL = 'not_null'.freeze
    NULL = 'null'.freeze
    NOT_IN = 'not_in'.freeze
    IN = 'in'.freeze
    NOT_CONT_ANY = 'not_cont_any'.freeze
    CONT_ANY = 'cont_any'.freeze

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
    # @return [Set{String}]
    #
    def array
      @predicates_on_array.dup
    end
    module_function :array

    # Returns predicates for values
    # @return [Set{String}]
    #
    def value
      @predicates_on_value.dup
    end
    module_function :value

    # Returns all predicates
    # @return [Set{String}]
    #
    def all
      @predicates_on_value + @predicates_on_array
    end
    module_function :all
  end
end
