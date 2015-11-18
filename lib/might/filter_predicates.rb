module Might
  # Contains contains with all supported predicates
  #
  module FilterPredicates
    ON_VALUE = %w(
      not_eq eq
      does_not_match matches
      gt lt
      gteq lteq
      not_cont cont
      not_start start
      not_end end
      not_true true
      not_false false
      blank present
      not_null null
    )

    ON_ARRAY = %w(
      not_in in
      not_cont_any cont_any
    )

    ALL = ON_VALUE + ON_ARRAY
  end
end
