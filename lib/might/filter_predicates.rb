module Might
  # Contains contains with all supported predicates
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

    ON_VALUE = [
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
    ].freeze

    ON_ARRAY = [
      NOT_IN, IN,
      NOT_CONT_ANY, CONT_ANY
    ].freeze

    ALL = ON_VALUE + ON_ARRAY
  end
end
