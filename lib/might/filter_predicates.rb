module Might
  # Contains contains with all supported predicates
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
    IN  = 'in'
    NOT_CONT_ANY = 'not_cont_any'
    CONT_ANY = 'cont_any'

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
    ]

    ON_ARRAY = [
      NOT_IN, IN,
      NOT_CONT_ANY, CONT_ANY
    ]

    ALL = ON_VALUE + ON_ARRAY
  end
end
